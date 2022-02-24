class Gping < Formula
  desc "Ping, but with a graph"
  homepage "https://github.com/orf/gping"
  url "https://github.com/orf/gping/archive/gping-v1.3.0.tar.gz"
  sha256 "6624ccfcd0abec42e356e8b09e4a33fe04c66c4d32a805235f984d3a7624ed8f"
  license "MIT"
  head "https://github.com/orf/gping.git", branch: "master"

  # The GitHub repository has a "latest" release but it can sometimes point to
  # a release like `v1.2.3-post`, `v1.2.3-post2`, etc. We're checking the Git
  # tags because the author of `gping` requested that we omit `post` releases:
  # https://github.com/Homebrew/homebrew-core/pull/66366#discussion_r537339032
  livecheck do
    url :stable
    regex(/^gping[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6d765ccf11cdceca6b3b1bf406cd835f3d2dff403943fbdd7710f72a1bc0945c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1e017d379dd6aec6187488dfb82e371ab23d1dbfc8a9ed2f10dd4fe45def08db"
    sha256 cellar: :any_skip_relocation, monterey:       "234d9cc183fa6f405384e4b37019a7165d6f4120b74843d77da6f6a95ad58779"
    sha256 cellar: :any_skip_relocation, big_sur:        "fb4bae7c54fd41aa3f321a805727ad1c40440bde88fb69f348901d7ae076ac28"
    sha256 cellar: :any_skip_relocation, catalina:       "f480fd25f60b819c6e00883a01eb5970d4276c6c1445774554d2a74071e566c1"
  end

  depends_on "rust" => :build

  def install
    cd "gping" do
      system "cargo", "install", *std_cargo_args
    end
  end

  test do
    require "pty"
    require "io/console"

    r, w, pid = PTY.spawn("#{bin}/gping google.com")
    r.winsize = [80, 130]
    sleep 1
    w.write "q"

    screenlog = r.read
    # remove ANSI colors
    screenlog.encode!("UTF-8", "binary",
      invalid: :replace,
      undef:   :replace,
      replace: "")
    screenlog.gsub!(/\e\[([;\d]+)?m/, "")

    assert_match "google.com (", screenlog
  ensure
    Process.kill("TERM", pid)
  end
end
