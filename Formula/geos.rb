class Geos < Formula
  desc "Geometry Engine"
  homepage "https://trac.osgeo.org/geos"
  url "http://download.osgeo.org/geos/geos-3.6.1.tar.bz2"
  sha256 "4a2e4e3a7a09a7cfda3211d0f4a235d9fd3176ddf64bd8db14b4ead266189fc5"

  bottle do
    cellar :any
    sha256 "d061c3cbff08cef91394e3cc3d7e47c6142bc7ca87a6e0209042faf508f30b20" => :sierra
    sha256 "30ee76270ea0c4c8de5c3477a2e5484bf18119805dc0b5785026980866acc7da" => :el_capitan
    sha256 "0104a14d3fb41c0b7b6ae62c0cb6c5fd75746cc90fab1ed42244627d9d3770e2" => :yosemite
  end

  option :universal
  option :cxx11
  option "with-php", "Build the PHP extension"
  option "without-python", "Do not build the Python extension"
  option "with-ruby", "Build the ruby extension"

  depends_on "swig" => :build if build.with?("python") || build.with?("ruby")

  def install
    ENV.universal_binary if build.universal?
    ENV.cxx11 if build.cxx11?

    # https://trac.osgeo.org/geos/ticket/771
    inreplace "configure" do |s|
      s.gsub! /PYTHON_CPPFLAGS=.*/, %Q(PYTHON_CPPFLAGS="#{`python-config --includes`.strip}")
      s.gsub! /PYTHON_LDFLAGS=.*/, 'PYTHON_LDFLAGS="-Wl,-undefined,dynamic_lookup"'
    end

    args = [
      "--disable-dependency-tracking",
      "--prefix=#{prefix}",
    ]

    args << "--enable-php" if build.with?("php")
    args << "--enable-python" if build.with?("python")
    args << "--enable-ruby" if build.with?("ruby")

    system "./configure", *args
    system "make", "install"
  end

  test do
    system "#{bin}/geos-config", "--libs"
  end
end
