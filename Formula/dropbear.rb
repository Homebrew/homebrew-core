class Dropbear < Formula
  desc "Small SSH server/client for POSIX-based system"
  homepage "https://matt.ucc.asn.au/dropbear/dropbear.html"
  url "https://matt.ucc.asn.au/dropbear/releases/dropbear-2020.80.tar.bz2"
  sha256 "d927941b91f2da150b2033f1a88b6a47999bf0afb1493a73e9216cffdb5d7949"

  bottle do
    cellar :any_skip_relocation
    sha256 "4d01e165cf0ae95e4cbab848383505099d9170c724572516186415b662e0a0a0" => :catalina
    sha256 "9722249d984de8c41078036eed5b3b82a4d30a0f232ba5d38c44a535340b45c7" => :mojave
    sha256 "bcdab71d6cf8b8d9e0ca4d4c09e9468311edb7ae52455909f094ea6e8beebada" => :high_sierra
  end

  head do
    url "https://github.com/mkj/dropbear.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
  end

  def install
    ENV.deparallelize

    if build.head?
      system "autoconf"
      system "autoheader"
    end
    system "./configure", "--prefix=#{prefix}",
                          "--enable-pam",
                          "--enable-zlib",
                          "--enable-bundled-libtom",
                          "--sysconfdir=#{etc}/dropbear"
    system "make"
    system "make", "install"
  end

  test do
    testfile = testpath/"testec521"
    system "#{bin}/dbclient", "-h"
    system "#{bin}/dropbearkey", "-t", "ecdsa", "-f", testfile, "-s", "521"
    assert_predicate testfile, :exist?
  end
end
