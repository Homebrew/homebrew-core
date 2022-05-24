class Logcli < Formula
  desc "Run LogQL queries against a Loki server"
  homepage "https://grafana.com/loki"
  url "https://github.com/grafana/loki/archive/refs/tags/v2.5.0.tar.gz"
  sha256 "f9ca9e52f4d9125cc31f9a593aba6a46ed6464c9cd99b2be4e35192a0ab4a76e"
  license "AGPL-3.0-only"
  head "https://github.com/grafana/loki.git", branch: "main"

  livecheck do
    formula "loki"
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "88e5bc3436ea5c2f26c8af399b6b6f6f54eacf8026130cd43f409ecb2779e4c3"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0dcb73f437252873bae70c90d45128b77e66c4f24923d40a17d31cbbad316a07"
    sha256 cellar: :any_skip_relocation, monterey:       "22db2cd34d128a91c89c40b25fcbc6f5161f81559a1d4bdbd91ca668698ac339"
    sha256 cellar: :any_skip_relocation, big_sur:        "3ce5085f2333685aae241263f81d4ea6ae4f882a219dbaddd3cf68db2b3d85ad"
    sha256 cellar: :any_skip_relocation, catalina:       "32a2e0e5a268502e3963f40534170b833cc2183a3e1eee547eb1cd333773c5a7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "42067a26764bbb5b3eeb1d03e5979a3f390107fbaeed9cd40df6f03e1c4f5132"
  end

  # Bump to 1.18 on the next release, if possible.
  depends_on "go@1.17" => :build
  depends_on "loki" => :test

  resource "testdata" do
    url "https://raw.githubusercontent.com/grafana/loki/f5fd029660034d31833ff1d2620bb82d1c1618af/cmd/loki/loki-local-config.yaml"
    sha256 "27db56559262963688b6b1bf582c4dc76f82faf1fa5739dcf61a8a52425b7198"
  end

  def install
    system "go", "build", *std_go_args, "./cmd/logcli"
  end

  test do
    port = free_port

    testpath.install resource("testdata")
    inreplace "loki-local-config.yaml" do |s|
      s.gsub! "3100", port.to_s
      s.gsub! "/tmp", testpath
    end

    fork { exec Formula["loki"].bin/"loki", "-config.file=loki-local-config.yaml" }
    sleep 3

    output = shell_output("#{bin}/logcli --addr=http://localhost:#{port} labels")
    assert_match "__name__", output
  end
end
