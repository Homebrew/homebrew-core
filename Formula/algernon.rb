class Algernon < Formula
  desc "Pure Go web server with Lua, Markdown, HTTP/2 and template support"
  homepage "https://algernon.roboticoverlords.org/"
  url "https://github.com/xyproto/algernon/archive/1.12.8.tar.gz"
  sha256 "562d6f1145980d5e4c8eaefc2780801b163d228720599f22165135182018d6bf"
  license "MIT"
  revision 1
  version_scheme 1
  head "https://github.com/xyproto/algernon.git"

  livecheck do
    url "https://github.com/xyproto/algernon/releases/latest"
    regex(%r{href=.*?/tag/v?(\d+(?:\.\d+)+)["' >]}i)
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "86789f00d6b8d3469c5d3df5087149a72d1673cb7f2b7e31360672a6193e4eb2" => :catalina
    sha256 "71d88d3e20c865c299b4083ce9143b8f5594be8be2d5e6a511d6d7187b8465c3" => :mojave
    sha256 "b78c41a051aac0d969b8d7b49507a11e3e1b69990efe22aa88f9d5a5d544eb46" => :high_sierra
  end

  depends_on "go@1.14" => :build

  def install
    system "go", "build", "-trimpath", "-mod=vendor", "-o", bin/"algernon"

    bin.install "desktop/mdview"
    prefix.install_metafiles
  end

  test do
    port = free_port
    pid = fork do
      exec "#{bin}/algernon", "-s", "-q", "--httponly", "--boltdb", "tmp.db",
                              "--addr", ":#{port}"
    end
    sleep 20
    output = shell_output("curl -sIm3 -o- http://localhost:#{port}")
    assert_match /200 OK.*Server: Algernon/m, output
  ensure
    Process.kill("HUP", pid)
  end
end
