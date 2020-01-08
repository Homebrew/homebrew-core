class Geos < Formula
  desc "Geometry Engine"
  homepage "https://trac.osgeo.org/geos"
  url "https://download.osgeo.org/geos/geos-3.8.0.tar.bz2"
  sha256 "99114c3dc95df31757f44d2afde73e61b9f742f0b683fd1894cbbee05dda62d5"

  bottle do
    cellar :any
    sha256 "796dd5584ab4d12a520fc6b4425d2b85ad3979d114a14925b51d021e8379b263" => :catalina
    sha256 "dbc37cb1275dd952d81063c99a6850866b00872fafee3891dbb38626ed6a5cef" => :mojave
    sha256 "ddc40581ddb90eb111a4d745508aba760dfdae7adc533c517c1b27759009c4c0" => :high_sierra
  end

  depends_on "swig" => :build
  depends_on "python"

  def install
    # https://trac.osgeo.org/geos/ticket/771
    inreplace "configure" do |s|
      s.gsub! /PYTHON_CPPFLAGS=.*/, %Q(PYTHON_CPPFLAGS="#{`python3-config --includes`.strip}")
      s.gsub! /PYTHON_LDFLAGS=.*/, 'PYTHON_LDFLAGS="-Wl,-undefined,dynamic_lookup"'
    end

    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--enable-python",
                          "PYTHON=#{Formula["python"].opt_bin}/python3"
    system "make", "install"
  end

  test do
    system "#{bin}/geos-config", "--libs"
  end
end
