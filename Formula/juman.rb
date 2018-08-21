class Juman < Formula
  desc "Japanese morphological analysis system"
  homepage "http://nlp.ist.i.kyoto-u.ac.jp/index.php?JUMAN"
  url "http://nlp.ist.i.kyoto-u.ac.jp/nl-resource/juman/juman-7.01.tar.bz2"
  sha256 "64bee311de19e6d9577d007bb55281e44299972637bd8a2a8bc2efbad2f917c6"

  bottle do
    sha256 "36bae86cd2b24c5b3b4e75aed31ab0cf5da261b7a77e7ffe8a9b279ca3b801d6" => :mojave
    sha256 "7e2b144bf77ccdb11ae0166827dd45feae62a950de00310dcb863d7f926a9510" => :high_sierra
    sha256 "5c1dfea7f62d1afce55c9d1ed2478f9ff3b1744285fbbf08c29eb171cc672fa7" => :sierra
    sha256 "6bd46cdc6ff4e159463f8d4fecda2b803c3054ec28305f3baa1ea4969c4da723" => :el_capitan
    sha256 "b2ccfe90011dead77ca0789cbdcdf30aa24e2ebcd3dd19c8d01b6adacbf7c816" => :yosemite
    sha256 "f959168856e884fcdadea2d19e9ebfa3ee6cdafb6e133588fce001de677fbe2a" => :mavericks
    sha256 "098a7ddfd7cd9524e34473c286465ef63864de21c4a23c91d449b1bd5272b090" => :mountain_lion
  end

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    result = `echo \xe4\xba\xac\xe9\x83\xbd\xe5\xa4\xa7\xe5\xad\xa6 | juman | md5`.chomp
    assert_equal "a5dd58c8ffa618649c5791f67149ab56", result
  end
end
