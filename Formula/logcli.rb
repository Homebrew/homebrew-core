class Logcli < Formula
  desc "Run LogQL queries against a Loki server"
  homepage "https://grafana.com/loki"
  url "https://github.com/grafana/loki/archive/v1.6.1.tar.gz"
  sha256 "25d130f47aa4408ea9def4096253a37d4df4e0c44bdd59aa7e9a69f81e6fbd17"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "af69580a9106b8b08ee73b65aaa21e159004337a07f976c9c1cf027c6b45d502" => :catalina
    sha256 "2a50707940dff101b465d2f5bf4a926ea506081a80ba711681ca399cf1ba3cca" => :mojave
    sha256 "759365beafe8a2996eaeaea081a1020b545a2ed28b8a74e017b4d63823b30193" => :high_sierra
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
