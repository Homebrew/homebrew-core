class Algernon < Formula
  desc "Pure Go web server with Lua, Markdown, HTTP/2 and template support"
  homepage "https://github.com/xyproto/algernon"
  url "https://github.com/xyproto/algernon/archive/refs/tags/v1.13.0.tar.gz"
  sha256 "8327c1687990386eb5a48d15fd46fc69e17d400c29d726b34f6087c9c4887b9c"
  license "BSD-3-Clause"
  version_scheme 1
  head "https://github.com/xyproto/algernon.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "54189c2ada66deb8da6f827a6e23f1085c3455f6b3fed8265b2c21a3a38fc654"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a37f04e1db3b4db20f9e4bfc1e0e6a7bca9cca80555fe8c66295a79384cf7608"
    sha256 cellar: :any_skip_relocation, monterey:       "9379b04db4148f53b9d435e0868d3a0af2041c3c45402e55a150e24d4ec070da"
    sha256 cellar: :any_skip_relocation, big_sur:        "aed213b4eb7454bc8cd6d6fcb4bda60c821497dac5dde820dc41c891af856ed5"
    sha256 cellar: :any_skip_relocation, catalina:       "5069b96a60ade19ce3bb97a020cbb432eda8fd65a60e241755d3294048e4e656"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2250b3159431e738598e16abbfc0f6b621ebcbe5e76444915a642de6c84245ba"
  end

  depends_on "go" => :build

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
