class Gping < Formula
  desc "Ping, but with a graph"
  homepage "https://github.com/orf/gping"
  url "https://github.com/orf/gping/archive/gping-v1.6.2.tar.gz"
  sha256 "e1f4106ede6a18a57ce35c095e17d0a9071e22ca9e6ca34075c006b7f61d943f"
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
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b655d0551b65d3c755b84704da847188d0de4f762853a74b1c96574116f506a8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f3ef8c50ab161e27260b45bf87ce43affde8c7348c2e5789cef28783b5b116c8"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5001034577b62ddaf94a4c967b3765d15d4c5c2b9f53cca7d3460f852086b548"
    sha256 cellar: :any_skip_relocation, ventura:        "989a1abb0884633bb980e098b5e275021ef826845599dff0a8256e3a507540d2"
    sha256 cellar: :any_skip_relocation, monterey:       "40b1582c1b28082e55463188390fef8adbd4a6ed4053ba68e3042116495c71e9"
    sha256 cellar: :any_skip_relocation, big_sur:        "c7fa0963b8a1ef5c77ff1dab9251f9214ca19a8df83c6251c5f3b1311da2fa85"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "59e7e71e819417c922619ed23f59c5bfc8cb23b6013bd9a242cb118679b5780f"
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
