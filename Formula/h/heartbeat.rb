class Heartbeat < Formula
  desc "Lightweight Shipper for Uptime Monitoring"
  homepage "https://www.elastic.co/beats/heartbeat"
  url "https://github.com/elastic/beats.git",
      tag:      "v8.11.3",
      revision: "bfdd9fb0a3c4eeeacf5a5bc2110164a177e4cb08"
  license "Apache-2.0"
  head "https://github.com/elastic/beats.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "762daa0ba52b7b0adf1f536c26f546a02148f6f0781bce4eda3230c692d700ab"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c677f18592653af3023d7605c25f469baee8ca5ddaf7af64a5aa7608441a839b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "741321af44a580ea033507c89f8e3119c16331091997e35ec60d5ef49433fd40"
    sha256 cellar: :any_skip_relocation, sonoma:         "44bb263d25cff3b55279c46731c81b4ae0851c893599fc332906ac3896856d69"
    sha256 cellar: :any_skip_relocation, ventura:        "dbed55186ba67cc8d11c928d6dde93ff9eabb9bfcb0b5d4023bb8103c4a20720"
    sha256 cellar: :any_skip_relocation, monterey:       "68b93c7bcfcc696b5e46bd5bc78a1961a0970fe5db5d571c12c6a0b2990d8c4d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a9b80692afb2fc151a703c3aacda46a2290bee6ea1de6753539d93da9ce10a1c"
  end

  depends_on "go" => :build
  depends_on "mage" => :build

  uses_from_macos "python" => :build
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
