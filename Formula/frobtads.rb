class Frobtads < Formula
  desc "TADS interpreter and compilers"
  homepage "http://www.tads.org/frobtads.htm"
  url "http://www.tads.org/frobtads/frobtads-1.2.3.tar.gz"
  sha256 "88c6a987813d4be1420a1c697e99ecef4fa9dd9bc922be4acf5a3054967ee788"

  bottle do
    sha256 "57bd02f13719c266c9473320cd5bbe641fe1b2f8244c4e97cd35694fd78e38ba" => :el_capitan
    sha256 "c7cd9d7b88e197913decad46a34f9e31853265739a3458c32dc52ae158d610d3" => :yosemite
    sha256 "862ee593c96541cdd53a0019cb7f0cc09f6944e62cd451e9875af81fe742ce5d" => :mavericks
  end

  head do
    url "https://github.com/realnc/frobtads.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  def install
    system "./bootstrap" if build.head?
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    assert_match /FrobTADS #{version}$/, shell_output("#{bin}/frob --version")
  end
end
