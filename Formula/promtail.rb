class Promtail < Formula
  desc "Log agent for Loki"
  homepage "https://grafana.com/loki"
  url "https://github.com/grafana/loki/archive/v2.7.4.tar.gz"
  sha256 "b5521c0d12699f59ddf48ff7eaacddaa56abe90da4579f35c18f0752fc8e95c0"
  license "AGPL-3.0-only"
  head "https://github.com/grafana/loki.git", branch: "main"

  livecheck do
    formula "loki"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "be88dca50585092c4552ec7979d4d439b7f22aef59aa6b78dd976ce610bfa9e6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "30ccdf7058856321cb91fecbb2af5059f6df81cd0700fe8f84192d7316cdbc2e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b314548a9d2ac77aead9f9a046ebaa54d820e08ba472e727243a45bc9775f76b"
    sha256 cellar: :any_skip_relocation, ventura:        "eeba9d98dfe5f33f2270de138f37ff70245f8c6a5eb9f9f78f67a2e44d6311f1"
    sha256 cellar: :any_skip_relocation, monterey:       "1bf742efd6812f253c407b28cc8b8e35f2faea0e0c8728080253df8c8940dc05"
    sha256 cellar: :any_skip_relocation, big_sur:        "c642e8eda6b339ede1e81364c2cc1cf79cdc1310f761b8febdc61950ef821b63"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8fe4438c845d5f6b6f3f1eef1fb2f0d14f2692d9167ba61a6d03b75e83066068"
  end

  # TODO: Try `go@1.20` or newer on the next release
  depends_on "go@1.19" => :build

  on_linux do
    depends_on "systemd"
  end

  def install
    cd "clients/cmd/promtail" do
      system "go", "build", *std_go_args(ldflags: "-s -w")
      etc.install "promtail-local-config.yaml"
    end
  end

  service do
    run [opt_bin/"promtail", "-config.file=#{etc}/promtail-local-config.yaml"]
    keep_alive true
    working_dir var
    log_path var/"log/promtail.log"
    error_log_path var/"log/promtail.log"
  end

  test do
    port = free_port

    cp etc/"promtail-local-config.yaml", testpath
    inreplace "promtail-local-config.yaml" do |s|
      s.gsub! "9080", port.to_s
      s.gsub!(/__path__: .+$/, "__path__: #{testpath}")
    end

    fork { exec bin/"promtail", "-config.file=promtail-local-config.yaml" }
    sleep 3

    output = shell_output("curl -s localhost:#{port}/metrics")
    assert_match "log_messages_total", output
  end
end
