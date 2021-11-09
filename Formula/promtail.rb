class Promtail < Formula
  desc "Log agent for Loki"
  homepage "https://grafana.com/loki"
  url "https://github.com/grafana/loki/archive/v2.4.1.tar.gz"
  sha256 "a26c22941b406b8c42e55091c23798301181df74063aaaf0f678acffc66d8c27"
  license "AGPL-3.0-only"

  livecheck do
    formula "loki"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4987df46858631ab3e8814369d8a14c39b7c16ce0f89d15804f39df56bdfb1d5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "75a9fedd0102f2060b48e5c1e92bd5f4f712a4eaf2a341be8148a17811324be5"
    sha256 cellar: :any_skip_relocation, monterey:       "cba989c739754603552b92a6ec1f37321451991d34fa77fdb5ba8ba0019c3f9e"
    sha256 cellar: :any_skip_relocation, big_sur:        "5d129aeb7363268a1ec581f8cebb47cb97ad2ad505e41316efbb2dde3c6bf46e"
    sha256 cellar: :any_skip_relocation, catalina:       "ac725d799923900f2d8f588e2ae7cf03150fa4c19cd44dc7ef00b8970bedb10b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d0c464e473ac3fee348318feb8ea2bf945b3e54a6cb13541689bf931597f226a"
  end

  depends_on "go" => :build

  on_linux do
    depends_on "systemd"
  end

  def install
    cd "clients/cmd/promtail" do
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
