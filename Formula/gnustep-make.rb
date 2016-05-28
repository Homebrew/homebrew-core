class GnustepMake < Formula
  desc "Basic GNUstep Makefiles"
  homepage "http://gnustep.org"
  url "http://ftpmain.gnustep.org/pub/gnustep/core/gnustep-make-2.6.8.tar.gz"
  sha256 "603ed2d1339b44d154ea25229330acdedb6784b9c802b3797b2fefe3d2200064"

  bottle do
    cellar :any_skip_relocation
    sha256 "a810d2598a9e35a24c04fb6f86f84422acca27aeade6cd75e9584445f8a1b004" => :el_capitan
    sha256 "fe5e51c24948e4aaba4704cd8d1c478b366c739225b3f65bda0c920879f6f5f6" => :yosemite
    sha256 "f8c9ccee8f22ac1e8fa0c3fc9a6e054e32fb722a287d32759ec7b579d9cf0b5c" => :mavericks
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
