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
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "14e5969ae003e4adede7f1c59bc7813acea79cb19f438796ada77dc621612869"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "343a3153a0af6ad0fc1ad27939eb9a2dbc9f379bd5bf6b4e373b9fd2f87d3ed4"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "401c99640d17d66677f419c8da8719618c499e02e2b6f70b74eefec104378912"
    sha256 cellar: :any_skip_relocation, ventura:        "aeb0c363d972073a22cfc94844c61c8da268cef9dc68c9316167d28d9c709b66"
    sha256 cellar: :any_skip_relocation, monterey:       "a0f090b5d513eedc54de13a6f954a33ac0a126ea2b1bd1dde009629bd0854707"
    sha256 cellar: :any_skip_relocation, big_sur:        "3f25029f7b5dcf462b1b6e3d3a69e246d881201a7f9ab35657cd11dd25916f6a"
    sha256 cellar: :any_skip_relocation, catalina:       "fff5b9bfa21524d8f9bff2266978dc7dcb4a8a6a35a19eb20397d3993a0e3445"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1fb0615287ba76cf2372cc91154d458c881d175e877b4140eeab7487282a7269"
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
