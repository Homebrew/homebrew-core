class Promtail < Formula
  desc "Log agent for Loki"
  homepage "https://grafana.com/loki"
  url "https://github.com/grafana/loki/archive/refs/tags/v3.6.7.tar.gz"
  sha256 "28daa4ee3633c8cc45bc6d62a7b470216dc502ff97cac46eb2d5fec228fd498a"
  license "AGPL-3.0-only"
  head "https://github.com/grafana/loki.git", branch: "main"

  livecheck do
    formula "loki"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f48fb5dc9271f872c256cc83bc1bdd30a6f2d8327dcc8c932588ce0b16f8f922"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9217129da6ddd325fc3366a73218a7ed0c068fb88590d4505bdd07e9f10281e0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b689f8b9a28dbbc35f18aece412d4dedb3520871ea9e7becfbfff21bb9b68257"
    sha256 cellar: :any_skip_relocation, sonoma:        "66257ccc3768cf35c6c1afd5144fa6dd4da4a3ac8c59c93beff36a33868b644b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bef2ec5dd4e0abe7cfb5c5f7e3a7a2d5f1a8ab6c2e8296365a488b2c7db0a4ef"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dd9ddf08ef0bf66effe742801929db14a1af136ce21e86cf1dc3921408937851"
  end

  depends_on "go" => :build

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

    spawn bin/"promtail", "-config.file=promtail-local-config.yaml"
    sleep 3
    sleep 3 if OS.mac? && Hardware::CPU.intel?

    output = shell_output("curl -s localhost:#{port}/metrics")
    assert_match "log_messages_total", output
  end
end
