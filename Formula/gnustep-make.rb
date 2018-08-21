class GnustepMake < Formula
  desc "Basic GNUstep Makefiles"
  homepage "http://gnustep.org"
  url "http://ftpmain.gnustep.org/pub/gnustep/core/gnustep-make-2.7.0.tar.gz"
  sha256 "90a01cbfb68aafe01c4cc4123121ebd2da0e1e2076795b5682f0833fddf311ce"

  bottle do
    cellar :any_skip_relocation
    sha256 "ec339c4c3d597509b68e07ff092582075e5d60d07f4dbc8ca208915b3b6b1451" => :mojave
    sha256 "2f9b5760d28e77b0ffc8f51f9adc639ea69f97f3105da2c21cae90d08132b53e" => :high_sierra
    sha256 "7a2905ce98897c3f74f4802b66f27105c095f078074a874335f2286bec1957db" => :sierra
    sha256 "a7fc1782bf06e382a4f240f648e55d09a2294202b7f2a7bedf506823acb67fa4" => :el_capitan
    sha256 "5e005875a2b2b9edd967edcedf14ee4e927312d7e97878ea14d509e10e25186b" => :yosemite
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
