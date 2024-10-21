class Promtail < Formula
  desc "Log agent for Loki"
  homepage "https://grafana.com/loki"
  url "https://github.com/grafana/loki/archive/refs/tags/v3.2.1.tar.gz"
  sha256 "4d39632d6cb60a3252ca294558aa7eff2c9bb4b66b62920f4691389d293b6d7b"
  license "AGPL-3.0-only"
  head "https://github.com/grafana/loki.git", branch: "main"

  livecheck do
    formula "loki"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ec12a7dfa896bc28d680174acb931f0a0608781c352128a84853a6623b0d6aa1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bf29b63fdb7090073793d47fb2609e641d162fbdc79a891ba18fdc4a7f00b273"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "137471b53132ed00460101b894e232e0cbf39e4a86b26fc947e779b2a7caf4e0"
    sha256 cellar: :any_skip_relocation, sonoma:        "4529ef1f5f1ab24cd6b16cddb797ab8892b7164a1d8f958f1a6b32b17fa2aaf7"
    sha256 cellar: :any_skip_relocation, ventura:       "df46d75311db8fcad5135888adbb5c731b4de4b5c63f6d162b28b969e2b766ef"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dd79c33036cdeaee20150bcc8c3ad233f94b6126ab47375c48c520c4eadd22f1"
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
