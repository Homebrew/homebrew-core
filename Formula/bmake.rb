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
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ea6d347e27b41d0fe9e672910c829123de6563da61b665b2d0f17a45d7f14994"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "801ad5c98a414c1efc6be2d83ffe15c2c25af0ef3d973421ea2a1ed6864856bc"
    sha256                               monterey:       "cc70133aa230c37eca6973c9759b8d08ffcc1d3ffc9f147f8ac73cc978d075b9"
    sha256                               big_sur:        "467fbaa19a541763345a973dc9041a2a88c6ad4eef1e31bf660814c32bdff409"
    sha256                               catalina:       "a9d6f26a78e81862230f1cee75746431fb049235dd811028b032fe6f52716bec"
    sha256                               x86_64_linux:   "e420bc8442cf5eb48296e98d142a9de2000baf2b600444c1f6cd1e4937f2725d"
  end

  def install
    # Don't pass flat_namespace to dependents build
    inreplace "mk/lib.mk", "-flat_namespace -undefined suppress", "-undefined dynamic_lookup"

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
