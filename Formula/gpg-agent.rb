class GpgAgent < Formula
  desc "GPG key agent"
  homepage "https://www.gnupg.org/"
  url "https://gnupg.org/ftp/gcrypt/gnupg/gnupg-2.0.31.tar.bz2"
  mirror "https://www.mirrorservice.org/sites/ftp.gnupg.org/gcrypt/gnupg/gnupg-2.0.31.tar.bz2"
  sha256 "095558cfbba52fba582963e97b0c016889570b4712d6b871abeef2cf93e62293"

  bottle do
    sha256 "aad65c67de59226ab94dcd307f75dfd007cb4a8d3050863d23c9c39f72dd4b87" => :high_sierra
    sha256 "7767c0f021cfab5e062d18069bd7bbbfd82249e1a0d80b5bfbf4eee125c617d4" => :sierra
    sha256 "6f07d8e495b5eee2d0b13d0b1397c543ac710d5416fbb3571ec67a5937650bab" => :el_capitan
  end

  keg_only "GPG 2.1.x ships an internal gpg-agent which it must use"

  depends_on "libgpg-error"
  depends_on "libgcrypt"
  depends_on "libksba"
  depends_on "libassuan"
  depends_on "pth"
  depends_on "pinentry"

  def install
    # don't use Clang's internal stdint.h
    ENV["gl_cv_absolute_stdint_h"] = "#{MacOS.sdk_path}/usr/include/stdint.h"

    # Adjust package name to fit our scheme of packaging both
    # gnupg 1.x and 2.x, and gpg-agent separately
    inreplace "configure" do |s|
      s.gsub! "PACKAGE_NAME='gnupg'", "PACKAGE_NAME='gpg-agent'"
      s.gsub! "PACKAGE_TARNAME='gnupg'", "PACKAGE_TARNAME='gpg-agent'"
    end

    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--enable-agent-only",
                          "--with-pinentry-pgm=#{Formula["pinentry"].opt_bin}/pinentry",
                          "--with-scdaemon-pgm=#{Formula["gnupg@2.0"].opt_libexec}/scdaemon"
    system "make", "install"
  end

  def caveats
    <<~EOS
      Remember to add "use-standard-socket" to your ~/.gnupg/gpg-agent.conf
      file.
    EOS
  end

  test do
    system "#{bin}/gpg-agent", "--help"
  end
end
