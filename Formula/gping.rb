class Gping < Formula
  desc "Ping, but with a graph"
  homepage "https://github.com/orf/gping"
  url "https://github.com/orf/gping/archive/gping-v1.6.1.tar.gz"
  sha256 "f27dc8aadd7f323861e8700d47efd13199f924fe0b2e20fef1f537bed01c1454"
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
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "32b5b84cbd74f589d2787f0c144e27f69343928cc476ca1d15941b1fd17065e1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fdd3b3dcedc6492dfa51e3908d0b71a0d0940af880ce843fe1c53d7b9df22594"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "bda2dfd08211709b9a8345b183fcb58701205b4df6471453c29d7fc5adda052b"
    sha256 cellar: :any_skip_relocation, ventura:        "16cbb4bfcd73ef2268f2781acefc1630f17fe17fe8ef98bc43be6ddfb8ea2138"
    sha256 cellar: :any_skip_relocation, monterey:       "c5046a4867eccf3a870fc9d665e93c6571cfc502f5d5b8e6d488b5239fe51808"
    sha256 cellar: :any_skip_relocation, big_sur:        "1c6c0405648f145b74208a84c406120dccc09ecbab0963d97a4ad701935ac1ed"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fd828754566f51ecc7bf9298656b942975f01c9ef69b3316ba89ff3a0a6ee046"
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
