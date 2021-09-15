class Gping < Formula
  desc "Ping, but with a graph"
  homepage "https://github.com/orf/gping"
  url "https://github.com/orf/gping/archive/gping-v1.2.5.tar.gz"
  sha256 "de1c6bd2b51d71194eccaeb1ba6559e92a0f9ef272d0cfdf2613fe35d42b042a"
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
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "2c344af5166f08bc9555b19d14edb97631b1cc9aa1f9dec0376feff949840a36"
    sha256 cellar: :any_skip_relocation, big_sur:       "bd0f0869e339181eed2e146b5ebda76991d7ae84b57aaeb4c8994f56a7ae01c2"
    sha256 cellar: :any_skip_relocation, catalina:      "6a8d816136da1828fb3fbc01ae24fc65031f620c65559956602c66210454128a"
    sha256 cellar: :any_skip_relocation, mojave:        "1243ba40412a13eb8597043a727ce3c0dedc81d812e60f50e2821972c23c2620"
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
