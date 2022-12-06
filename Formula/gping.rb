class Gping < Formula
  desc "Ping, but with a graph"
  homepage "https://github.com/orf/gping"
  url "https://github.com/orf/gping/archive/gping-v1.5.1.tar.gz"
  sha256 "d7f4f3e3971e420d40a1fc94346891677e59506afcdc392c4209a9aa901bc1e2"
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
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "748a723053509ad0ac1511a49c1bdd949deb1710cb568d0950c43d553d588b7f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "11b174b463e97b0d62495b762f8591b952af157ab31664d591253b08b8cf673c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c54c2e0bb608a633ff80113a4a3f8f9f878ae89f1d3b7687edcb5805c30eb08e"
    sha256 cellar: :any_skip_relocation, ventura:        "833cdaa324ba95504ec2f35b49f5ba6a486880d604852deb0a72197a19f6c3d0"
    sha256 cellar: :any_skip_relocation, monterey:       "ae7218507fdd44c1aad5ece7256d3e83f91842a31e5b5ed82a192ab35bde016c"
    sha256 cellar: :any_skip_relocation, big_sur:        "b7a83b3e12640638b9545b4952f4c586343b16f710d483986ddd7dbb8b9d7363"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "37de6cd0849f2b15e67d35837deb03fbe4e85853b963cf9f99a0b0d8d1c01602"
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
