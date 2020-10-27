class Logcli < Formula
  desc "Run LogQL queries against a Loki server"
  homepage "https://grafana.com/loki"
  url "https://github.com/grafana/loki/archive/v2.0.0.tar.gz"
  sha256 "e7ab246d98be52caf7b475245f5ea2cf62fb00f61d6e5377f31423414847556b"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
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
