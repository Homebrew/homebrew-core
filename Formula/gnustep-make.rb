class GnustepMake < Formula
  desc "Basic GNUstep Makefiles"
  homepage "http://gnustep.org"
  url "http://ftpmain.gnustep.org/pub/gnustep/core/gnustep-make-2.6.8.tar.gz"
  sha256 "603ed2d1339b44d154ea25229330acdedb6784b9c802b3797b2fefe3d2200064"

  bottle do
    cellar :any_skip_relocation
    sha256 "72bdbf93d49c36d17dea050197fbe857aa44d56339993bc23b063e4a52f7880b" => :sierra
    sha256 "1598a85b3b9bbf721fb75d57c36d5dd6bc5810ec0f5281b35d2e8a13d24edf12" => :el_capitan
    sha256 "a944ce4d2cd6131d53837f1e674806a073f534e15870ffd01c484aaab8702f8c" => :yosemite
    sha256 "e1aed229b3582202cc41d91a208a0e92b36cdb05007450ddd1e6c824e9cde952" => :mavericks
  end

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--with-config-file=#{prefix}/etc/GNUstep.conf",
                          "--enable-native-objc-exceptions"
    system "make", "install", "tooldir=#{libexec}"
  end

  test do
    assert_match shell_output("#{libexec}/gnustep-config --variable=CC").chomp, ENV.cc
  end
end
