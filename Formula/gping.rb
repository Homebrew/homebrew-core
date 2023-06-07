class Gping < Formula
  desc "Ping, but with a graph"
  homepage "https://github.com/orf/gping"
  url "https://github.com/orf/gping/archive/gping-v1.12.0.tar.gz"
  sha256 "63b5a60d1389e44c5baef07cec41d148b454798683baf220bb260d450a4906b8"
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
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c982676a9fbb12e9630da81f8b1c4bab9a8640b5426a55787029294ca8f5955f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5f98596a5eb92f7c78d971996ff8f989b53772430a488774aa31075c7189ef9b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6097f7084dec3a4fe85c295b347c6a11ed43c7270acecf595ba517513c204a67"
    sha256 cellar: :any_skip_relocation, ventura:        "184d100df9ed266c560522fdd1fd03f4c0875837971787b35fe380a169f66636"
    sha256 cellar: :any_skip_relocation, monterey:       "c9c5e58e505ef8eae3ea55e48b2fd13f89b01df083837130588e7cae61f41cbc"
    sha256 cellar: :any_skip_relocation, big_sur:        "c08feeb8b62480e9e267067f7129451b525bf3fea92396c8fdb760383c5237a7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3ae515009bf6f929c4589e519e9e15d066b19665078b87fb086f0ccf4b017df3"
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
