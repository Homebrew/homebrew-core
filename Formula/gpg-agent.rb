class GpgAgent < Formula
  desc "GPG key agent"
  homepage "https://www.gnupg.org/"
  url "https://gnupg.org/ftp/gcrypt/gnupg/gnupg-2.0.31.tar.bz2"
  mirror "https://www.mirrorservice.org/sites/ftp.gnupg.org/gcrypt/gnupg/gnupg-2.0.31.tar.bz2"
  sha256 "095558cfbba52fba582963e97b0c016889570b4712d6b871abeef2cf93e62293"

  bottle do
    sha256 "c555d26b1e5e2e22f3aa005c5418673e1df7db02e815c650847aaf5e18b11cf0" => :high_sierra
    sha256 "a59b4f9f60137448d591e1c702dd5e1548e424058af87a4da318a7ef8cffb23f" => :sierra
    sha256 "edf496c4ea0cce7b46a1ef1d39f6b0feae02b8479f2772bc3dc448a4d5f7cdc8" => :el_capitan
    sha256 "b5cb2ff4333b5e7416d876daedc1170a98217c12789a4dae48c9794457822059" => :yosemite
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
