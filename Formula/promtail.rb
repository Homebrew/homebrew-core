class Promtail < Formula
  desc "Log agent for Loki"
  homepage "https://grafana.com/loki"
  url "https://github.com/grafana/loki/archive/v2.8.1.tar.gz"
  sha256 "8b75f877445d60c86472eac77d122e0cf1f85d5f771d2a2a1a39241e6f6c5d5f"
  license "AGPL-3.0-only"
  head "https://github.com/grafana/loki.git", branch: "main"

  livecheck do
    formula "loki"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "235ac5137ea637ada479adef37871933ff65ea197766f18f7800ca156d32f644"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ada023872645d9f0017be0f19cf741426271b454e2eed7617653698e434043d7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "235ac5137ea637ada479adef37871933ff65ea197766f18f7800ca156d32f644"
    sha256 cellar: :any_skip_relocation, ventura:        "7144add4df857c98a08fbd9bdc03875003df2349adf511bf200637e9ac09d259"
    sha256 cellar: :any_skip_relocation, monterey:       "7144add4df857c98a08fbd9bdc03875003df2349adf511bf200637e9ac09d259"
    sha256 cellar: :any_skip_relocation, big_sur:        "7144add4df857c98a08fbd9bdc03875003df2349adf511bf200637e9ac09d259"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "09085dc4a90d8584c275d9314fe35ca722b50c32cfd4211a1cbefe04d7aeaf7a"
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
