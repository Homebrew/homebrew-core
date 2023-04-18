class Algernon < Formula
  desc "Pure Go web server with Lua, Markdown, HTTP/2 and template support"
  homepage "https://github.com/xyproto/algernon"
  url "https://github.com/xyproto/algernon/archive/refs/tags/v1.14.0.tar.gz"
  sha256 "2d30fe7a3f7c9b985f5fde7d6035888ad0c31ae4342fb38a96404de320ccd883"
  license "BSD-3-Clause"
  version_scheme 1
  head "https://github.com/xyproto/algernon.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0847b46518e3a13df5fea6b9f2ce7041ac04783caeb63d0bbfa662cecab98c54"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b3a10d9df74f1d8b83ca5d25baa94b835d8afb8d5aa48e131239a01bd2509ca0"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d78426493c03ad68d59c8a8d8a0b404e09654cae38fbce211f68b0c0746ddfd9"
    sha256 cellar: :any_skip_relocation, ventura:        "64f3fbe6f770b0148199a0a60d9dc8720a799c154addf42da4641c333fa1ac1a"
    sha256 cellar: :any_skip_relocation, monterey:       "b4da942b8ad07b1887b4d2580f3773a7ac91dd014d8f9a9fde6052966162fda8"
    sha256 cellar: :any_skip_relocation, big_sur:        "d0a3a8a255f39ea72c98c289f23230016e8ba5492fa6c44437792741d4cb1e24"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3a03f96f82ddf6c79892267dfa6cfb456fdb51d57876bf7f8e2d830540e97637"
  end

  # Support for go 1.20 is merged upstream but not yet landed in a tag:
  # https://github.com/xyproto/algernon/commit/00f29f8bcd0da772041a96fa9b57f7e1e21a6654
  # Remove on next release.
  depends_on "go@1.19" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "-mod=vendor"

    bin.install "desktop/mdview"
  end

  test do
    port = free_port
    pid = fork do
      exec "#{bin}/algernon", "-s", "-q", "--httponly", "--boltdb", "tmp.db",
                              "--addr", ":#{port}"
    end
    sleep 20
    output = shell_output("curl -sIm3 -o- http://localhost:#{port}")
    assert_match(/200 OK.*Server: Algernon/m, output)
  ensure
    Process.kill("HUP", pid)
  end
end
