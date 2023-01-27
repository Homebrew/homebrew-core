class Bmake < Formula
  desc "Portable version of NetBSD make(1)"
  homepage "https://www.crufty.net/help/sjg/bmake.html"
  url "https://www.crufty.net/ftp/pub/sjg/bmake-20230126.tar.gz"
  sha256 "864f7218582cf790ec73b20b7105425cb9ffa335222541772f0313306b6a0bc4"
  license "BSD-3-Clause"

  livecheck do
    url "https://www.crufty.net/ftp/pub/sjg/"
    regex(/href=.*?bmake[._-]v?(\d{6,8})\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "94216c08aa9a53469c8199536cadfb4277f7a7aac16b0c7139b7a47006536f70"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "62673ff3137dc9592b8767a8e88c7a282de533e6323b9281bbb93c11452ccee4"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "66c3e458fdba0c8286e30db34a04661673b7c275ed0f0811db888b9f0d3745e2"
    sha256                               ventura:        "7a0c69c9299ad36dcedc2dc4a21d92662613bbfc28039dd17241200ecd532842"
    sha256                               monterey:       "79cb481ef936b22aad6f58084ec394f0ff28fc6698f56f80f641b741e18e6566"
    sha256                               big_sur:        "e83c79f073ac8b77a90da01a8d77e55b7685a694963b8e5043f90e325df50c77"
    sha256                               x86_64_linux:   "0ef90e9aa2cb2e9314980768aabd08285c783352c917a2302eac75e8b06fb274"
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
