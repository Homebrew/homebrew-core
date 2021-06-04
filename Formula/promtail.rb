class Promtail < Formula
  desc "Log agent for Loki"
  homepage "https://grafana.com/loki"
  url "https://github.com/grafana/loki/archive/v2.2.1.tar.gz"
  sha256 "4801a9418c913bcca5e597d09f0f7ce1f5a7ce879f8dba3e8fe86057cb592bcf"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "cd1c8a80055b249865bc16ef4f2244e50fac22ab2ff408454deb1bf23c001664"
    sha256 cellar: :any_skip_relocation, big_sur:       "96b089d1cf25ce0638b5bde8532313d31e13007e7e1395f5bbb576cb43596823"
    sha256 cellar: :any_skip_relocation, catalina:      "1e1ef057e6531655bd9c719d6a9bb0ae37d642b047a95d930d37f3169357258b"
    sha256 cellar: :any_skip_relocation, mojave:        "0ea6d2a1505803ca144e4f8d3574e5be38e82ff068ec207d4ff27bfaea9ac4ad"
  end

  depends_on "go" => :build

  def install
    cd "cmd/promtail" do
      system "go", "build", *std_go_args
      etc.install "promtail-local-config.yaml"
    end
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
