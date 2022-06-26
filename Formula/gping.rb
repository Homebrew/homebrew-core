class Gping < Formula
  desc "Ping, but with a graph"
  homepage "https://github.com/orf/gping"
  url "https://github.com/orf/gping/archive/gping-v1.3.2.tar.gz"
  sha256 "1ab71ca45cb5da317d77774eff96d5868486d03ea1cedff008cbafcaf880332b"
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
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bdaa992823296eeef01673ca877ff36115d74e4fea6aa44be0491dba49c40b98"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5be8d82100101c780ff3b52441e61b289d666b7d68206f76fa372ca4251783b1"
    sha256 cellar: :any_skip_relocation, monterey:       "719f4eff54e840f308c95091256d2a9ef7bf32a7b84a18a06ce3105b617ea21d"
    sha256 cellar: :any_skip_relocation, big_sur:        "4ea96dd46996e64f8927c613fcabdd779f165e55a5b7c858e8182dfb6f737029"
    sha256 cellar: :any_skip_relocation, catalina:       "cc33d10a6e9ae1e6ed2b1347d16b6597f1f803c5c38dcd1b85142dd4147cafa8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "540af6c67f6a2bb924ebbd4e4aa9765cb001e53929815a4e2946e562a6021b1a"
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
