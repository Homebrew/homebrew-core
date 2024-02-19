class Promtail < Formula
  desc "Log agent for Loki"
  homepage "https://grafana.com/loki"
  url "https://github.com/grafana/loki/archive/refs/tags/v2.9.4.tar.gz"
  sha256 "d8d663b3fedbf529a53e9fbf11ddfb899ddaaf253b3b827700ae697c21688b38"
  license "AGPL-3.0-only"
  head "https://github.com/grafana/loki.git", branch: "main"

  livecheck do
    formula "loki"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "35a0b414c4b92d54ff821d3374a58d87deda8665550c97d528f204b5f23dd763"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a17e2d40542c3c8a673b074658da72021d7b2a3395bd356023d841856c981b99"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c441033e17872025358d3be7bdb3dedb5a807bc42546fe0bccb29a25b51c3d3d"
    sha256 cellar: :any_skip_relocation, sonoma:         "83ad16238671f68eddee333fe2ea995b286cb944a17262759be7c59d18c60440"
    sha256 cellar: :any_skip_relocation, ventura:        "78b0e5f1bc8ba0cc4940d700a76288a615b2e5c7159a3a14f1397ed5dd89936a"
    sha256 cellar: :any_skip_relocation, monterey:       "438f84787aa271f4488c2fa8688df79d3af5f206bb5f2b4466937a795f0cac5f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "748b7c66a6772b1c6645e29dd1cbc11bc3c104aa1df4596355db1c509a9ec491"
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
