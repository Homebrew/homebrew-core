class Promtail < Formula
  desc "Log agent for Loki"
  homepage "https://grafana.com/loki"
  url "https://github.com/grafana/loki/archive/v2.1.0.tar.gz"
  sha256 "ceccc4e42a7158ca0bc49903a3fbe31c8cd55f85f50bac8a8bba9843b4f8cd6f"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "9f8cd2975f3ab3b7d9b8ef5fa9342b72fa41b004b598d09bcd03bb851c8790ba" => :big_sur
    sha256 "0e1a8756b5e834af38df562cb64c642994f315a3f3c3b6bf407f635715e3ba03" => :arm64_big_sur
    sha256 "0bec4681b981aae0c080c142b6ab75713cc93b993014b128bf1becd456c88282" => :catalina
    sha256 "9ff5316f9c200d2f4f9ed399e0a2a51ec51a930e8565539827f299035243b1b1" => :mojave
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
      s.gsub! /__path__: .+$/, "__path__: #{testpath}"
    end

    fork { exec bin/"promtail", "-config.file=promtail-local-config.yaml" }
    sleep 3

    output = shell_output("curl -s localhost:#{port}/metrics")
    assert_match "log_messages_total", output
  end
end
