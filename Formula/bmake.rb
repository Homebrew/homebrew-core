class Bmake < Formula
  desc "Portable version of NetBSD make(1)"
  homepage "https://www.crufty.net/help/sjg/bmake.html"
  url "https://www.crufty.net/ftp/pub/sjg/bmake-20220330.tar.gz"
  sha256 "4b46d95b6ae4b3311ba805ff7d5a19b9e37ac0e86880e296e2111f565b545092"
  license "BSD-3-Clause"

  livecheck do
    url "https://www.crufty.net/ftp/pub/sjg/"
    regex(/href=.*?bmake[._-]v?(\d{6,8})\.t/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e7fb3b9dde9cfae3104ad90df8c4bec26bec2da7957e45f705c68de5d0b29da6"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "86e2ab73eb983e55c9008d0a2e9b7a452aa4714c51968ffef351e501502c7da1"
    sha256                               monterey:       "35465bf9615ccf297c45315c54f2d24423a136d89d032bba3e768a1bac33b258"
    sha256                               big_sur:        "63400c4d08f286c5e14c0394f2994f39948dca884f673e6c6f400134c4afaf81"
    sha256                               catalina:       "2063d9ef8d86787598d41b606e5475b8282aae24d717d813b343acc22f35505b"
    sha256                               x86_64_linux:   "e06166d7e19f8d6bf9326253f6153c5832d47cf439b0f0ba113d6f2c9b51e3a3"
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
