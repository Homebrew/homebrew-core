class Gping < Formula
  desc "Ping, but with a graph"
  homepage "https://github.com/orf/gping"
  url "https://github.com/orf/git-workspace/archive/v1.2.1.tar.gz"
  sha256 "42413850a298f8d82737b7b1370b8c15be55927368d109eba7a599e498a441c1"
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
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b5823a8930d2cacc64392fbaa90c8d8838c2d87a99a58f539c8e69eea4eea690"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bc944233b3fa628ef33a8372ca7e90522610244e2646f49a2381d461b701ae58"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8b8fc82bde28402d018b8630e604172854a6fc22db7b141eb6787b0421a19bd0"
    sha256 cellar: :any_skip_relocation, ventura:        "02f4f0e7e1b821eb926b35d62136f0d160b51a889a488980655e509c83b8b9dd"
    sha256 cellar: :any_skip_relocation, monterey:       "7a1487e3eb95e0c498fc0e23739b5be8f6b58c4774da6ddf4b0dfb7772719c5d"
    sha256 cellar: :any_skip_relocation, big_sur:        "20e874ad72625c92a7b32bc06c5c74b1097c65d296046648cb893ffbd0eda8d0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1b1cb71a924e0162020828d1af4d56a852173abea6431239e10047aef2ac546b"
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
