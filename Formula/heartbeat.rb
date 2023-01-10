class Heartbeat < Formula
  desc "Lightweight Shipper for Uptime Monitoring"
  homepage "https://www.elastic.co/beats/heartbeat"
  url "https://github.com/elastic/beats.git",
      tag:      "v8.6.0",
      revision: "561a3e1839f1a50ce832e8e114de399b2bee2542"
  license "Apache-2.0"
  head "https://github.com/elastic/beats.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "518053ff298890a0811cecbdb2a41b8ddd82da8283956c7e4ce97afbf1f7cff8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "64083c67ae33ef522a455bb2c1968c3e9c92ec4560a16a18ce694aec4ccc658c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "dd706b678f94af4e046ddaf9d3deb43429f9587e51bf738d0d6ee6dbaebf0ea1"
    sha256 cellar: :any_skip_relocation, ventura:        "8fccf4cc991444e6c715d93418ac41a6f6a149ee3455351cf3ba9a2d6c6677fc"
    sha256 cellar: :any_skip_relocation, monterey:       "4e45569653779940ca6fae527d0642956fe7eaee8d3c854c1f8b8acde38c5428"
    sha256 cellar: :any_skip_relocation, big_sur:        "5ef1a8a965546722f83119d0275a4a38ff521954d239d7bc771add477c103297"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9b0aa64b3d77a291046659dacc367526cd3e4c350d5c2283377745ae9b7be5d3"
  end

  depends_on "go" => :build
  depends_on "mage" => :build
  depends_on "python@3.11" => :build
  uses_from_macos "netcat" => :test

  def install
    # remove non open source files
    rm_rf "x-pack"

    cd "heartbeat" do
      # prevent downloading binary wheels during python setup
      system "make", "PIP_INSTALL_PARAMS=--no-binary :all", "python-env"
      system "mage", "-v", "build"
      ENV.deparallelize
      system "mage", "-v", "update"

      (etc/"heartbeat").install Dir["heartbeat.*", "fields.yml"]
      (libexec/"bin").install "heartbeat"
    end

    (bin/"heartbeat").write <<~EOS
      #!/bin/sh
      exec #{libexec}/bin/heartbeat \
        --path.config #{etc}/heartbeat \
        --path.data #{var}/lib/heartbeat \
        --path.home #{prefix} \
        --path.logs #{var}/log/heartbeat \
        "$@"
    EOS

    chmod 0555, bin/"heartbeat" # generate_completions_from_executable fails otherwise
    generate_completions_from_executable(bin/"heartbeat", "completion", shells: [:bash, :zsh])
  end

  def post_install
    (var/"lib/heartbeat").mkpath
    (var/"log/heartbeat").mkpath
  end

  service do
    run opt_bin/"heartbeat"
  end

  test do
    # FIXME: This keeps stalling CI when tested as a dependent. See, for example,
    # https://github.com/Homebrew/homebrew-core/pull/91712
    return if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"].present?

    port = free_port

    (testpath/"config/heartbeat.yml").write <<~EOS
      heartbeat.monitors:
      - type: tcp
        schedule: '@every 5s'
        hosts: ["localhost:#{port}"]
        check.send: "hello\\n"
        check.receive: "goodbye\\n"
      output.file:
        path: "#{testpath}/heartbeat"
        filename: heartbeat
        codec.format:
          string: '%{[monitor]}'
    EOS
    fork do
      exec bin/"heartbeat", "-path.config", testpath/"config", "-path.data",
                            testpath/"data"
    end
    sleep 5
    assert_match "hello", pipe_output("nc -l #{port}", "goodbye\n", 0)

    sleep 5
    output = JSON.parse((testpath/"data/meta.json").read)
    assert_includes output, "first_start"

    (testpath/"data").glob("heartbeat-*.ndjson") do |file|
      s = JSON.parse(file.read)
      assert_match "up", s["status"]
    end
  end
end
