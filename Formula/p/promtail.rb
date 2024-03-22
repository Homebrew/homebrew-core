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
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "115233fe5c81184516f85a0b39972052acf9536a18b09837b51025a64402d693"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "41f1d32e78ce8dab6c104d53c403d2dec6dd0d26508ea0b0be66787ace06cbaf"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6013f05059499c0395cd3cc6308908c6ffeebaafb22338f6b8c54030caefaa71"
    sha256 cellar: :any_skip_relocation, sonoma:         "07500469abb982f6aa4212d552db8d91210392c08646df359b5576c43d791baa"
    sha256 cellar: :any_skip_relocation, ventura:        "7b40e70f8940a76e50d4acf334d7d0616e239bcbcaa28cf797625cf30834a863"
    sha256 cellar: :any_skip_relocation, monterey:       "1d0b93e1ce39b3b74f635347445503db7470efc1058bfdfc9c7de6b831532e51"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3120ce52b6cd742810596ebf3b39a944057681437e8ffda01342494610fce056"
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
