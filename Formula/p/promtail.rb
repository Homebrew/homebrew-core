class Promtail < Formula
  desc "Log agent for Loki"
  homepage "https://grafana.com/loki"
  url "https://github.com/grafana/loki/archive/refs/tags/v2.9.6.tar.gz"
  sha256 "d3642bb140dbaf766069a587ae6b966576304dfdda3a932bf6e9a79fc8146b17"
  license "AGPL-3.0-only"
  head "https://github.com/grafana/loki.git", branch: "main"

  livecheck do
    formula "loki"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ae56f6540a66b2bf1608a262a5ce7a6374ee745a5618de450b56bafa962eb8b6"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1a633f80d8ec1293277d78f3cff01d45e3c3067e5430cca689bf7adb1adbdfad"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a77dc3e010d0313e25a4cbe5fef6c44d4a57bdf0bb9055d1fbeb9d6a4a485c72"
    sha256 cellar: :any_skip_relocation, sonoma:         "8638739a029fee7cdb3213a666de7ad236cef8c9228344051657acf4aa7f1607"
    sha256 cellar: :any_skip_relocation, ventura:        "bfdd67ce3655eb0c73e63f2942ad696192b9c93fff0cf7690cfcd70531cb5a9b"
    sha256 cellar: :any_skip_relocation, monterey:       "e0a4a1af71a19dfe11dc709c0c7b95ab4539b907eb334597f3e172a259360690"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d9e9e13440582741ae71e78366689481b2a9f1da61093eb6a15b0090c6afa25e"
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
