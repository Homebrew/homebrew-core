class Algernon < Formula
  desc "Pure Go web server with Lua, Markdown, HTTP/2 and template support"
  homepage "https://github.com/xyproto/algernon"
  url "https://github.com/xyproto/algernon/archive/refs/tags/v1.17.5.tar.gz"
  sha256 "5636b87961a456454ca646b1057d12eb59fed31785d12aefd1ff8d2cef2ee712"
  license "BSD-3-Clause"
  version_scheme 1
  head "https://github.com/xyproto/algernon.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "cd3d6332fb7db0a31e44041b94e26e3460f48a0d6c2e20046d69aa7b04fc6451"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b370e1dbb640a07953a4362fc853b327c9c211c3c0b03cda47c6d0196d0951f4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bf9db802c62a5741d05964a3d82ff3795d9ab74f5a2d81500367a35931fa938f"
    sha256 cellar: :any_skip_relocation, sonoma:        "de64c1a719b13cf8b3f2dbc463943f02317f1d7d9688ea4ef075344eb35daed2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "45f4add8f549a5f172bd83bc32b5935d59529b09922146da090416349c16fdb9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3c40a6a85665817beafa31562044e36431d3a241e7070becbb9e280f08b6a9ec"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "-mod=vendor"

    bin.install "desktop/mdview"
  end

  test do
    port = free_port
    pid = fork do
      exec bin/"algernon", "-s", "-q", "--httponly", "--boltdb", "tmp.db",
                              "--addr", ":#{port}"
    end
    sleep 20
    output = shell_output("curl -sIm3 -o- http://localhost:#{port}")
    assert_match(/200 OK.*Server: Algernon/m, output)
  ensure
    Process.kill("HUP", pid)
  end
end
