class Libiptcdata < Formula
  desc "Virtual package provided by libiptcdata0"
  homepage "https://libiptcdata.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/libiptcdata/libiptcdata/1.0.4/libiptcdata-1.0.4.tar.gz"
  sha256 "79f63b8ce71ee45cefd34efbb66e39a22101443f4060809b8fc29c5eebdcee0e"

  bottle do
    rebuild 1
    sha256 "dcd03624950eb47746659ac044f32735c45ebc89a8d8c457bb6db47dcda8f955" => :mojave
    sha256 "711d2412e24e7cfa0e519e60c7205e46d544d480892988dbb6e2c6039dc653f1" => :high_sierra
    sha256 "d87011cbe7d98af0df3210ee1a01aaf35da267d9894b095ba031911a980d8c4e" => :sierra
    sha256 "37747abe5597a40dec5a741919eaa46bedc42472bb909b9a09c4a200e5d592d4" => :el_capitan
    sha256 "14f6b3a649e0d944768e5e3a1e4d44e1efd0389fdeaa5740993b10ee7a42c718" => :yosemite
    sha256 "e88aff2cc7949c8c05608811f894bd6816d797eeffe74f35118168168512738c" => :mavericks
    sha256 "3656316c8836547affe91fa29e9ea4067ac6774a9c9a08aef5fb296f4330e5f2" => :mountain_lion
  end

  depends_on "gettext"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end
end
