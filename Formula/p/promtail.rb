class Promtail < Formula
  desc "Log agent for Loki"
  homepage "https://grafana.com/loki"
  url "https://github.com/grafana/loki/archive/refs/tags/v3.1.1.tar.gz"
  sha256 "d53a46e3ee51a258f49f865cc5795fe05ade1593237709417de0e1395b5a21cf"
  license "AGPL-3.0-only"
  head "https://github.com/grafana/loki.git", branch: "main"

  livecheck do
    formula "loki"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "506f13a12f0f514f595e12f852112f140f74f073441138e4a27296b0db8daa59"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4fed2ee96500369fe7f4686ce7cc70326c1098172b3fc292327c8af3b85b9767"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0a765e8bbf132a7118fef37ca4d6820909d1dbb802a8c5ec3b28c3b608b9cb39"
    sha256 cellar: :any_skip_relocation, sonoma:         "b1e5d55dd8916240931bf9a47a270e1cb887f69bd40d00bdb17d7ce6a5eb2057"
    sha256 cellar: :any_skip_relocation, ventura:        "c917279cda38db0f8381427079c368050c0b842ee9ba3fbbcbf1e4b001d02eae"
    sha256 cellar: :any_skip_relocation, monterey:       "7930d43cc63ac11772d0423493ea336ae723a03106b9b8f1b22bb23a210cafbb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "38b2151977c3cc0355cea76bcfa194db5d5a1f8ee363304a590f2e4e6467d20e"
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

    fork { exec bin/"promtail", "-config.file=promtail-local-config.yaml" }
    sleep 3

    output = shell_output("curl -s localhost:#{port}/metrics")
    assert_match "log_messages_total", output
  end
end
