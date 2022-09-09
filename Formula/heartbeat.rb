class Heartbeat < Formula
  desc "Lightweight Shipper for Uptime Monitoring"
  homepage "https://www.elastic.co/beats/heartbeat"
  url "https://github.com/elastic/beats.git",
      tag:      "v8.4.1",
      revision: "fe210d46ebc339459e363ac313b07d4a9ba78fc7"
  license "Apache-2.0"
  head "https://github.com/elastic/beats.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cfda1dab24ecad47e7a9606e2ce6d1cefe6da09f53429f9f394ac67c7926425c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "45d23b5a771b29f05a0d4a2fb96d1fdf74a7ba65f89e6d5667ea483a9bb86e4b"
    sha256 cellar: :any_skip_relocation, monterey:       "130f4659dcc2224410f59e95ce7df453a0cd140b760f02cdf9eaed1a8bbb05aa"
    sha256 cellar: :any_skip_relocation, big_sur:        "317bf0f311f3282f26c3bbf13eaa17ad75b4e77eca12f9f2536b16cb671bff7e"
    sha256 cellar: :any_skip_relocation, catalina:       "32b18e23b3c07c6a178bab978df17cf7638fe0b4647d80168a94a8bf783d7ed9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "48b5458051ea09a7c959ad69fdbf51bb2315390e30e80035879d2c2319f4397f"
  end

  depends_on "go" => :build
  depends_on "mage" => :build
  depends_on "python@3.10" => :build
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

      generate_completions_from_executable(bin/"heartbeat", "completion", shells: [:bash, :zsh])
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
