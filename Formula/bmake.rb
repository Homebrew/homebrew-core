class Bmake < Formula
  desc "Portable version of NetBSD make(1)"
  homepage "https://www.crufty.net/help/sjg/bmake.html"
  url "https://www.crufty.net/ftp/pub/sjg/bmake-20220924.tar.gz"
  sha256 "6e6c75e822ce30d470258fb4eec5fe6eb706aea36ef0b141e7e0852c13c706bb"
  license "BSD-3-Clause"

  livecheck do
    url "https://www.crufty.net/ftp/pub/sjg/"
    regex(/href=.*?bmake[._-]v?(\d{6,8})\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "38248a78e1be2bb2bcc4c1e5e9f7b38c2f7f2760d8feef0470cada264f0474c7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "243d1022938ede2cff029a21b9126e36854f41429319754526570d9894e34ac2"
    sha256                               monterey:       "9f8bbc4fe0bd3ace1145ad39d18d9b0df52b466ee275bedd19bcf9963f2dcbf3"
    sha256                               big_sur:        "e0445649d3fe33fb368fa878de9c5fe29179ee071c5430fd1eaa6589f8312060"
    sha256                               catalina:       "fcafb5dca9d9a797cb39f749ec5d27a639b5f4cd4fe484ddb12b323f0b1e8a63"
    sha256                               x86_64_linux:   "6a80a6929125737488fce6d67460d9a7d8f8727621fe4a32ddb10f3f3194628e"
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
