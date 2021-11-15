class Gping < Formula
  desc "Ping, but with a graph"
  homepage "https://github.com/orf/gping"
  url "https://github.com/orf/gping/archive/gping-v1.2.6.tar.gz"
  sha256 "e36d5bc02157708c803d1855be4b2a9daa27d077fffe86c58b12c746fdc04c8f"
  license "MIT"
  head "https://github.com/orf/gping.git"

  # The GitHub repository has a "latest" release but it can sometimes point to
  # a release like `v1.2.3-post`, `v1.2.3-post2`, etc. We're checking the Git
  # tags because the author of `gping` requested that we omit `post` releases:
  # https://github.com/Homebrew/homebrew-core/pull/66366#discussion_r537339032
  livecheck do
    url :stable
    regex(/^gping[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9a9b6784037c831bb6274931d1bada920ef5d763dcb7b0160aa267ce1c520725"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b7e1e08ebe385455747070b11e9f73c2cf3cbe3ce96860443ba7a709d125ed31"
    sha256 cellar: :any_skip_relocation, monterey:       "bd5c500528152cf1d4f3bcd5a67d9c7331bfc66058d3052a124b3c30c9e79e6a"
    sha256 cellar: :any_skip_relocation, big_sur:        "232fc5425ac0ea4de4860786ffb795a9cc6e1f1e4fe4ce00edbc65c45657164b"
    sha256 cellar: :any_skip_relocation, catalina:       "0d555937efeae1474a1a187ddeb0db14ba078dd012b4918d262d2e3f569369f9"
    sha256 cellar: :any_skip_relocation, mojave:         "ce0e519142ae3da1d3d4c9eecce6971bd6fd582c77c0eb8858dc49413d352395"
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
