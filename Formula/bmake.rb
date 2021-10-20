class Bmake < Formula
  desc "Portable version of NetBSD make(1)"
  homepage "https://www.crufty.net/help/sjg/bmake.html"
  url "https://www.crufty.net/ftp/pub/sjg/bmake-20211001.tar.gz"
  sha256 "cad7ef0fb41138050f8932af3a7ade16f7265b3f37ff6356703e0b1ad6542739"
  license "BSD-3-Clause"

  livecheck do
    url "https://www.crufty.net/ftp/pub/sjg/"
    regex(/href=.*?bmake[._-]v?(\d{6,8})\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "64d434169bc43d70b7c620369abd019e0c2005061e154bb0f8d722e7262267ec"
    sha256                               big_sur:       "98ff40de4a63d3dc568a577e59089f9e58a06a0b750a5f5adbe4252307d53ae7"
    sha256                               catalina:      "4c28d9e621ea9b03603ca96d390c9823ca94e3fb4d8049ecf7b32acbe6b1b7c3"
    sha256                               mojave:        "31f6737e5a2920fcc54736b6dcb140748f491967bc020eae635b52df038c2edf"
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
