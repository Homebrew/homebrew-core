class Gpgme < Formula
  desc "Library access to GnuPG"
  homepage "https://www.gnupg.org/related_software/gpgme/"
  url "https://www.gnupg.org/ftp/gcrypt/gpgme/gpgme-1.7.0.tar.bz2"
  mirror "https://www.mirrorservice.org/sites/ftp.gnupg.org/gcrypt/gpgme/gpgme-1.7.0.tar.bz2"
  sha256 "71f55fed0f2b3eaf7a606e59772aa645ce3ffff322d361ce359951b3f755cc48"

  bottle do
    cellar :any
    sha256 "0b4a59398bd222620a4d837d7e33ca3141dddd14886c68bccca15a177bda93c7" => :sierra
    sha256 "9764f539b4b51161127d95687c5611f9571ae2abde1dce66ba014a0f33d2bcc1" => :el_capitan
    sha256 "4a4c3e90175b02ded974a8a385b6d9799bcc2873c5a1087c558f350eb103934d" => :yosemite
  end

  depends_on "gnupg2"
  depends_on "libgpg-error"
  depends_on "libassuan"
  depends_on "pth"

  conflicts_with "argp-standalone",
                 because: "gpgme picks it up during compile & fails to build"

  fails_with :llvm do
    build 2334
  end

  def install
    # Check these inreplaces with each release.
    # At some point GnuPG will pull the trigger on moving to GPG2 by default.
    inreplace "src/gpgme-config.in" do |s|
      s.gsub! "@GPG@", "#{Formula["gnupg2"].opt_prefix}/bin/gpg"
      s.gsub! "@GPGSM@", "#{Formula["gnupg2"].opt_prefix}/bin/gpgsm"
    end

    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "--enable-static"
    system "make"
    system "make", "install"

    # avoid triggering mandatory rebuilds of software that hard-codes this path
    inreplace bin/"gpgme-config", prefix, opt_prefix
  end

  test do
    output = shell_output("#{bin}/gpgme-config --get-gpg").strip
    assert_equal "#{Formula["gnupg2"].opt_prefix}/bin/gpg", output
  end
end
