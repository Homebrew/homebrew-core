class Bmake < Formula
  desc "Portable version of NetBSD make(1)"
  homepage "https://www.crufty.net/help/sjg/bmake.html"
  url "https://www.crufty.net/ftp/pub/sjg/bmake-20230622.tar.gz"
  sha256 "b404c99d60289d78362d0ba0468f541d8a9b4215befee2fbe5750534849cec00"
  license "BSD-3-Clause"

  livecheck do
    url "https://www.crufty.net/ftp/pub/sjg/"
    regex(/href=.*?bmake[._-]v?(\d{6,8})\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0893b159997f1a73005850be0de7746a2e93ebd6c903eac6cb1425b231a9a236"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5ad480d4c70a1533c88be20258dd996b051b74279bdc2e1e99ec8bc3583300b4"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "07f9ec172ea9b042d44f16cabaca3d199bad72a4edb825b68a0e55b89adfcbf1"
    sha256                               ventura:        "7304e8272cb96d42b7ccaccec2b85f2b630251357641ddb26e61596be517bfcf"
    sha256                               monterey:       "8c6f7336cfbf50b794bf342ed09b91832b2564a52433fb6594bba025ece12274"
    sha256                               big_sur:        "4d1d1fa0aaccd601baf0802c05da2493c4d02e4f9f53ce678674b1b954c44722"
    sha256                               x86_64_linux:   "6518df48eaa8af88643db432050ccb09c7d72a28a5a4297e710bcb1bf38a01c8"
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
