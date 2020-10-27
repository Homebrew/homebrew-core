class Geos < Formula
  desc "Geometry Engine"
  homepage "https://trac.osgeo.org/geos"
  url "https://download.osgeo.org/geos/geos-3.8.1.tar.bz2"
  sha256 "4258af4308deb9dbb5047379026b4cd9838513627cb943a44e16c40e42ae17f7"
  revision 2

  livecheck do
    url "https://download.osgeo.org/geos/"
    regex(/href=.*?geos[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    cellar :any
    sha256 "13f14a442c17807aea92f6f10332ae9c59a8056190c5bba5fe2e606140a39198" => :catalina
    sha256 "297e6d7cac984603ae866f31747550d6cfdd473b6c2c83f735e890b4d70c51a2" => :mojave
    sha256 "d34ea2e3316cf9e1afdd89932168285985a1ca5790ae996c6fdba2df11e5621a" => :high_sierra
  end

  depends_on "swig" => :build
  depends_on "python@3.9"

  def install
    # https://trac.osgeo.org/geos/ticket/771
    inreplace "configure" do |s|
      s.gsub! /PYTHON_CPPFLAGS=.*/, %Q(PYTHON_CPPFLAGS="#{`python3-config --includes`.strip}")
      s.gsub! /PYTHON_LDFLAGS=.*/, 'PYTHON_LDFLAGS="-Wl,-undefined,dynamic_lookup"'
    end

    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--enable-python",
                          "PYTHON=#{Formula["python@3.9"].opt_bin}/python3"
    system "make", "install"
  end

  test do
    system "#{bin}/geos-config", "--libs"
  end
end
