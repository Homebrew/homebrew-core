class Gping < Formula
  desc "Ping, but with a graph"
  homepage "https://github.com/orf/gping"
  url "https://github.com/orf/gping/archive/gping-v1.6.3.tar.gz"
  sha256 "ed55d87d04482a137e1d56355095f56fb4977724032245e3547206274966c1c5"
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
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "56011981fb3fe0abe63188474765c6a8e1b76656c029b8ee04ad25bf9634916d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ebb0c463ce08a802209771fd594cf01c74c4fefa5b14b45e8c5b5936ff4a9635"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0c120b92431f31fa7291bbbd0504a62f685f8417e252563f21436b61e1debc64"
    sha256 cellar: :any_skip_relocation, ventura:        "b7c67285963c82e43d9a9229d6ea33f0e4d833fb8c4c0b628536bcbd0af07d42"
    sha256 cellar: :any_skip_relocation, monterey:       "33c5db1cb0e514b1bef194f73b5753903b232722429e7cce21a6718fc410a664"
    sha256 cellar: :any_skip_relocation, big_sur:        "c0d7393089a4365d09a93323bbe489cb1b8e8a8ed040d481c608644583f12974"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7a22520da2064751ee35a2cad9d5e001bc12018ce8405972d8bb33a66e34838e"
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
