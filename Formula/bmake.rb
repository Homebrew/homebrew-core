class Bmake < Formula
  desc "Portable version of NetBSD make(1)"
  homepage "https://www.crufty.net/help/sjg/bmake.html"
  url "https://www.crufty.net/ftp/pub/sjg/bmake-20211024.tar.gz"
  sha256 "b5a3305bdb328b1383982125e90785baa30bc2ff024a1b0fda3d5d5beca82ac9"
  license "BSD-3-Clause"

  livecheck do
    url "https://www.crufty.net/ftp/pub/sjg/"
    regex(/href=.*?bmake[._-]v?(\d{6,8})\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5de0409dc0181350d36bcaa0512463e140fd4a56cd755dd0de58dcb22d9c4982"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b83a451f2a2655ef3f805e309f612b2157e592de162f916cfb5e6367d3e86e76"
    sha256                               monterey:       "78ca4e2a547e873257b2a7631b02c602c67cf0641d1e15c93082936eabb6deea"
    sha256                               big_sur:        "666ff7e99b1792040e47e02e61969e34e5e338fbf5ae3577ae723eb6fbc423f3"
    sha256                               catalina:       "6182afba32e950f0f077110e3e9d6cb2fbe0017450b257cd364e8fbe68f02346"
    sha256                               x86_64_linux:   "b6a4a7a09aacf87a1f56b5ff81b124517c023b395a275c9286886b7cd18c25a4"
  end

  def install
    # Don't pre-roff cat pages.
    inreplace "mk/man.mk", "MANTARGET?", "MANTARGET"

    # -DWITHOUT_PROG_LINK means "don't symlink as bmake-VERSION."
    # shell-ksh test segfaults since macOS 11.
    args = ["--prefix=#{prefix}", "-DWITHOUT_PROG_LINK", "--install", "BROKEN_TESTS=shell-ksh"]
    system "sh", "boot-strap", *args

    man1.install "bmake.1"
  end

  test do
    (testpath/"Makefile").write <<~EOS
      all: hello

      hello:
      \t@echo 'Test successful.'

      clean:
      \trm -rf Makefile
    EOS
    system bin/"bmake"
    system bin/"bmake", "clean"
  end
end
