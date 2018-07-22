class Dropbear < Formula
  desc "Small SSH server/client for POSIX-based system"
  homepage "https://matt.ucc.asn.au/dropbear/dropbear.html"
  url "https://matt.ucc.asn.au/dropbear/releases/dropbear-2018.76.tar.bz2"
  sha256 "f2fb9167eca8cf93456a5fc1d4faf709902a3ab70dd44e352f3acbc3ffdaea65"

  bottle do
    cellar :any_skip_relocation
    sha256 "85068db760b390774919baa81ff724beec4ce909e9b05ca55e40d2a54e883ae2" => :high_sierra
    sha256 "7850b929f50189cb0e8a0bf1bff530d6ac0370495bd574cd0bf4a4b0cea6eed9" => :sierra
    sha256 "669b80b9322ce9be7747693b0008cd98f1ed243a0adbbdedc213ffdcacf79c37" => :el_capitan
  end

  head do
    url "https://github.com/mkj/dropbear.git"

    depends_on "automake" => :build
    depends_on "autoconf" => :build
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
