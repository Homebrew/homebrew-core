class Loki < Formula
  desc "Horizontally-scalable, highly-available log aggregation system"
  homepage "https://grafana.com/loki"
  url "https://github.com/grafana/loki/archive/v2.7.4.tar.gz"
  sha256 "b5521c0d12699f59ddf48ff7eaacddaa56abe90da4579f35c18f0752fc8e95c0"
  license "AGPL-3.0-only"
  head "https://github.com/grafana/loki.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6336717373a1be401798125bc47c9117a7784bc55af519967e5e78b387dff16e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4280791c24144a0782c8fa07bdae4fe6af991dd999955f6ef3b45e7810516c3c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a38d02cd82dcfc4babd6ece0f9d1f99f2e7fe10a78716c0a770aa5aa85d31829"
    sha256 cellar: :any_skip_relocation, ventura:        "4d80d3b968c1fe94632adf597a6aaf40aa8dcc9dc229f170eb9f1baa6deeb6ba"
    sha256 cellar: :any_skip_relocation, monterey:       "259a660f235699fc03f1db926248c313a0738bfd8c67fd642d70abf0edf42fe2"
    sha256 cellar: :any_skip_relocation, big_sur:        "b37e36d3e627df3e6833fe2af1ded9c951b95c6f6d2d3136d10b8bfe6b083c63"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1feaae58c5da873bb7a69a4c78f82e22580c3cb63d3c2033c194fbaecc5f8e07"
  end

  # TODO: Try `go@1.20` or newer on the next release
  depends_on "go@1.19" => :build

  def install
    cd "cmd/loki" do
      system "go", "build", *std_go_args(ldflags: "-s -w")
      inreplace "loki-local-config.yaml", "/tmp", var
      etc.install "loki-local-config.yaml"
    end
  end

  service do
    run [opt_bin/"loki", "-config.file=#{etc}/loki-local-config.yaml"]
    keep_alive true
    working_dir var
    log_path var/"log/loki.log"
    error_log_path var/"log/loki.log"
  end

  test do
    port = free_port

    cp etc/"loki-local-config.yaml", testpath
    inreplace "loki-local-config.yaml" do |s|
      s.gsub! "3100", port.to_s
      s.gsub! var, testpath
    end

    fork { exec bin/"loki", "-config.file=loki-local-config.yaml" }
    sleep 3

    output = shell_output("curl -s localhost:#{port}/metrics")
    assert_match "log_messages_total", output
  end
end
