class Bmake < Formula
  desc "Portable version of NetBSD make(1)"
  homepage "https://www.crufty.net/help/sjg/bmake.html"
  url "https://www.crufty.net/ftp/pub/sjg/bmake-20220418.tar.gz"
  sha256 "6ea7de515cba74f173dc14ee17b1488ae032582028d2e86ea12f70369cc896f5"
  license "BSD-3-Clause"

  livecheck do
    url "https://www.crufty.net/ftp/pub/sjg/"
    regex(/href=.*?bmake[._-]v?(\d{6,8})\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f154178c943f7d57a7afe81d12e0812fd60db4a71418e00ac7f74347ca628366"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2bffee032b042a7b31f30cd1dbf8762d4226487f0cdea6e02770057c8cbbace4"
    sha256                               monterey:       "e4b88b5b338cd15aee868373330659ec18a4acfb61fbd26da9bb788dc70a82f8"
    sha256                               big_sur:        "793f8f16fd82309cb8bddfa0b0d367e2b158362748b33230e3de48816f8bbc3f"
    sha256                               catalina:       "c25d1e795818a73984daf27c544ee9c06cda1b994dd214a3880de97976dbef3f"
    sha256                               x86_64_linux:   "1e8093d067c905bb6565294e75ff4d4f14ca0e3e8a74832b236e98907e825b9b"
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
