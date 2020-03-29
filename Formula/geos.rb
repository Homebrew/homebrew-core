class Geos < Formula
  desc "Geometry Engine"
  homepage "https://trac.osgeo.org/geos"
  url "https://download.osgeo.org/geos/geos-3.8.1.tar.bz2"
  sha256 "4258af4308deb9dbb5047379026b4cd9838513627cb943a44e16c40e42ae17f7"

  bottle do
    cellar :any
    sha256 "38483c00a7e8b1ee0aef1e6ae6f00352371a01ecc472ed3051dda1f1153382f8" => :catalina
    sha256 "cce9f7426c582a9999184ea4701b8c7968e10fd8fe0a42c616eaf07464c9eda3" => :mojave
    sha256 "890559f4dc3b16f759ae4f2ae75f8914c13a478aef3371db68d61a847384b312" => :high_sierra
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
