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
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5895cc8611675aeed96db27d71fe924a0b03d47fb8dd1dedb0ecfcd73f129c61"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1eceb7cc92d63bd1489cc37abca818b8f53242e85262e6f9581ef38ae7a19469"
    sha256 cellar: :any_skip_relocation, monterey:       "d204c7b5deb3cf721712f4ef70ca7317269039c464e951e01744042bfd51b3ed"
    sha256 cellar: :any_skip_relocation, big_sur:        "a278f9e6cabd288ab882dddd521e932eb9ec9b5ad6328ea0429cde1470aca6e7"
    sha256 cellar: :any_skip_relocation, catalina:       "ae4f17e8351d4533dbf7a5705f666b7ffa1f5768dbb20041d836b6c447c16315"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3c9b84a5a8dfe07dd10bf9a099d95110a1a8d60c439a6326b354747f241b238d"
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
