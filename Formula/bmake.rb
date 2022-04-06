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
    sha256 cellar: :any_skip_relocation, arm64_monterey: "74f3d7297d0e43e051ebc25df8e6b6c937522e1eb7a6895479f5eee0e65f1850"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8089cd842adb172141c112baf8db676d392e7849894b8aaee63401e4f8da01ae"
    sha256                               monterey:       "217b6ce35f1aeb7c59fbc35bbe04ade7290abb2b99c9538f7f375056088155c9"
    sha256                               big_sur:        "9590fa688cbaf287271bbca8548420dde6c62603bc4b075f70660b561d72e19e"
    sha256                               catalina:       "8da02f75fcdb4e85960a24da424e76c077cc58649935684d841e71521075827e"
    sha256                               x86_64_linux:   "7a53a49414a8e399b846c5451923ef2eef3de96ce6998b1d2d61b162a473bda2"
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
