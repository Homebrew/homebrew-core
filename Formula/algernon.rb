class Algernon < Formula
  desc "Pure Go web server with Lua, Markdown, HTTP/2 and template support"
  homepage "https://github.com/xyproto/algernon"
  url "https://github.com/xyproto/algernon/archive/1.12.14.tar.gz"
  sha256 "cab5b01923142e0326ea2a01797814bb2e8ea9f7c6c41a3ea0ae7df3b667e86e"
  license "MIT"
  version_scheme 1
  head "https://github.com/xyproto/algernon.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1da0199a842951f84657d8bcba74637c80ea2266576f9ff83d58aa0482c1ea85"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0eaa6910677a3aa0a1be868af31c73e7390d420f41c7950e905d6d52556bde0b"
    sha256 cellar: :any_skip_relocation, monterey:       "b2ad82e5156e897e0000273928084cb059ad30c73683b2f69cba53ce212fbcae"
    sha256 cellar: :any_skip_relocation, big_sur:        "ffe7eed6b3576166e41b66beecdccc47aabed4644119190a1534ec8210fb25cc"
    sha256 cellar: :any_skip_relocation, catalina:       "57e11ff2b146da5e254189058ec5502bda66d7213996daf8846756cca5de38ec"
    sha256 cellar: :any_skip_relocation, mojave:         "c06af8b3677a3d46e7be0160533e8da8b7512b848a24105d498c0a9b1d381125"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ccdca9ac607c215c4981e35dc13101c5acc0533edd1a5441bd3c874dea275b2a"
  end

  # Go 1.18 can be used after the next release (1.12.15 or later).
  depends_on "go@1.17" => :build

  def install
    system "go", "build", *std_go_args, "-mod=vendor"

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
