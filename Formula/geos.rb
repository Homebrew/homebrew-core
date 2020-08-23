class Geos < Formula
  desc "Geometry Engine"
  homepage "https://trac.osgeo.org/geos"
  url "https://download.osgeo.org/geos/geos-3.8.1.tar.bz2"
  sha256 "4258af4308deb9dbb5047379026b4cd9838513627cb943a44e16c40e42ae17f7"
  revision 1

  bottle do
    cellar :any
    sha256 "96668ef5d3512c74d8b9c029d36d52171e1d26e90935f4a108f51101c34df313" => :catalina
    sha256 "32ad6e55282b63e933ca43309989943da06bd34eb151b8ca2f81ca70eb4ef146" => :mojave
    sha256 "f17377d259393a9c0a7dd2ce41b7af6a09c2f4c137afe267ed7650adccc86c3f" => :high_sierra
  end

  depends_on "swig" => :build
  depends_on "python@3.8"

  def install
    # https://trac.osgeo.org/geos/ticket/771
    inreplace "configure" do |s|
      s.gsub! /PYTHON_CPPFLAGS=.*/, %Q(PYTHON_CPPFLAGS="#{`python3-config --includes`.strip}")
      s.gsub! /PYTHON_LDFLAGS=.*/, 'PYTHON_LDFLAGS="-Wl,-undefined,dynamic_lookup"'
    end

    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--enable-python",
                          "PYTHON=#{Formula["python@3.8"].opt_bin}/python3"
    system "make", "install"
  end

  test do
    system "#{bin}/geos-config", "--libs"
  end
end
