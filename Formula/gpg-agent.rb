# This formula tracks GnuPG stable. You can find GnuPG Modern via:
# brew install homebrew/versions/gnupg21
# At the moment GnuPG Modern causes too many incompatibilities to be in core.
class GpgAgent < Formula
  desc "GPG key agent"
  homepage "https://www.gnupg.org/"
  url "https://gnupg.org/ftp/gcrypt/gnupg/gnupg-2.0.30.tar.bz2"
  mirror "https://www.mirrorservice.org/sites/ftp.gnupg.org/gcrypt/gnupg/gnupg-2.0.30.tar.bz2"
  sha256 "e329785a4f366ba5d72c2c678a7e388b0892ac8440c2f4e6810042123c235d71"

  bottle do
    sha256 "9bebbc754c440be3ac5eada58600a2843d7922aed2a3c68a3329b5a94fbf6871" => :el_capitan
    sha256 "adf4ef470b329e18679ebd06efdb918b9e0220c7f5ab53937b476b48e11b37cd" => :yosemite
    sha256 "e9ada5047c3138066c28722dc281ea525bc78c3b368adf719541862c27192026" => :mavericks
    sha256 "65647148cf2989c7869f13d91f07441549e38cb4c13187df14134ce2fdbaf7b4" => :mountain_lion
  end

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
                          "--with-scdaemon-pgm=#{Formula["gnupg2"].opt_libexec}/scdaemon"
    system "make", "install"
  end

  def caveats; <<-EOS.undent
      Remember to add "use-standard-socket" to your ~/.gnupg/gpg-agent.conf
      file.
    EOS
  end

  test do
    system "#{bin}/gpg-agent", "--help"
  end
end
