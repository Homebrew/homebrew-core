class Gping < Formula
  desc "Ping, but with a graph"
  homepage "https://github.com/orf/gping"
  url "https://github.com/orf/gping/archive/gping-v1.7.0.tar.gz"
  sha256 "e40c8c89f8dd7b7f17f391a039817171c54128612c9b989b280f11bf07d1f511"
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
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "93dadc6c4c1185cea11825236545dcc1d0ef0a52c5b67d24836812b530ade331"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "680fb01aac0dd30968a5f27341f88518eaa159126336a834f02ab248fb966162"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "08a37a053ecb1703574572612ae4b210a9b156114be738a3133480f11cc38364"
    sha256 cellar: :any_skip_relocation, ventura:        "9e8a10068ad604accb86315db9f8a46313e18962a6fa2f09eb0e2078c8f6567f"
    sha256 cellar: :any_skip_relocation, monterey:       "5b9f70db578974912339418c207258031e9c35182fee3223e0d282ee747c01f6"
    sha256 cellar: :any_skip_relocation, big_sur:        "23b8217bc47c4d15c1dff47b4b941ee3f4f7f3907840f09dc0963fb558cd5f24"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c2ef7f3dc3a65218ed2f13d5cf3b343d0ad70664d57ddd9fe5d18b9a1f58b386"
  end

  depends_on "rust" => :build

  on_linux do
    depends_on "iputils"
  end

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

    begin
      screenlog = r.read
      # remove ANSI colors
      screenlog.encode!("UTF-8", "binary",
        invalid: :replace,
        undef:   :replace,
        replace: "")
      screenlog.gsub!(/\e\[([;\d]+)?m/, "")

      assert_match "google.com (", screenlog
    rescue Errno::EIO
      # GNU/Linux raises EIO when read is done on closed pty
    end
  ensure
    Process.kill("TERM", pid)
  end
end
