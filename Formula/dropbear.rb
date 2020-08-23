class Dropbear < Formula
  desc "Small SSH server/client for POSIX-based system"
  homepage "https://matt.ucc.asn.au/dropbear/dropbear.html"
  url "https://matt.ucc.asn.au/dropbear/releases/dropbear-2020.80.tar.bz2"
  sha256 "d927941b91f2da150b2033f1a88b6a47999bf0afb1493a73e9216cffdb5d7949"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "50a692b78c1958e54c5d5654cebc76c35df05f85d9b5d214caa1a95547f7a90d" => :catalina
    sha256 "8586e9012826a288865fab45cc08a0445fdee283680a24e2253f9854051a3510" => :mojave
    sha256 "371fd2eef7a59d0bf6fb8a35ce0f03f269af567e1ad31d5111be1cb846c93b6a" => :high_sierra
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
