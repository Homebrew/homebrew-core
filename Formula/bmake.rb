class Bmake < Formula
  desc "Portable version of NetBSD make(1)"
  homepage "https://www.crufty.net/help/sjg/bmake.html"
  url "https://www.crufty.net/ftp/pub/sjg/bmake-20220928.tar.gz"
  sha256 "c804b77de3feb8e31dee2a4c9fb1e9ec24c5a34764e7a2815c88b4ed01650e90"
  license "BSD-3-Clause"

  livecheck do
    url "https://www.crufty.net/ftp/pub/sjg/"
    regex(/href=.*?bmake[._-]v?(\d{6,8})\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e536bcfc52946f631c00183164126e6fd26006acd27b21e7da7b06ab310300d4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6a4b5a42dadc037e158e4cfe5571b3adf9882024be07147431adfe2617a96a31"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "95a14d565b7eec3c2ca6d3ecb793d69cc2a29eddbfa4d8a891afe66e2e2ae945"
    sha256                               ventura:        "1549aa5b240a604482f5e0b1838abcd88e40670847469d8515f6d66167be603c"
    sha256                               monterey:       "801cbdcbe3ce5ff1e436b511923e75074a825e7d8e34cc80f7ce151a64cfbcd0"
    sha256                               big_sur:        "d1e86cb4561374d4fa6d18c5b3e00afd4055640b10061c0c62b564ec8b522975"
    sha256                               catalina:       "ef5c79a571b508e81a122960f1b3fa11a0640ce315c0595ed3030ea6dce100ee"
    sha256                               x86_64_linux:   "0997b8c0c53881ead6f629f2a7d06dc88bcd6583c0ce6861d1e2351afe533e82"
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
