class Logcli < Formula
  desc "Run LogQL queries against a Loki server"
  homepage "https://grafana.com/loki"
  url "https://github.com/grafana/loki/archive/v2.1.0.tar.gz"
  sha256 "ceccc4e42a7158ca0bc49903a3fbe31c8cd55f85f50bac8a8bba9843b4f8cd6f"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "09885d26fa0980e0d51fd172b6d6b2fd6ff108cdfbc3c9ea0830f4deab12ad68" => :big_sur
    sha256 "0c65387f35a1b50797cc9d2744823b1bed26d41e6aa12c5df954a0d3e8d8a0e6" => :arm64_big_sur
    sha256 "b1a559d5d7d78851b73e659673d86f42d408d512f96d8bd38b46d9e41df0890b" => :catalina
    sha256 "8c42544e8dea3ed9042392ccacbd7de7e944cc7ab88ea27c899fdec52483cba4" => :mojave
    sha256 "4914fb833d0e4f4d4cb83bdd5b7b791bec1e432ea87cce75e02ff63e97dd28ba" => :high_sierra
  end

  depends_on "go" => :build
  depends_on "loki" => :test

  def install
    system "go", "build", *std_go_args, "./cmd/logcli"
  end

  test do
    port = free_port

    cp etc/"loki-local-config.yaml", testpath
    inreplace "loki-local-config.yaml" do |s|
      s.gsub! "3100", port.to_s
      s.gsub! var, testpath
    end

    fork { exec Formula["loki"].bin/"loki", "-config.file=loki-local-config.yaml" }
    sleep 3

    output = shell_output("#{bin}/logcli --addr=http://localhost:#{port} labels")
    assert_match "__name__", output
  end
end
