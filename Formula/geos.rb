class Geos < Formula
  desc "Geometry Engine"
  homepage "https://trac.osgeo.org/geos"
  url "http://download.osgeo.org/geos/geos-3.5.0.tar.bz2"
  sha256 "49982b23bcfa64a53333dab136b82e25354edeb806e5a2e2f5b8aa98b1d0ae02"

  bottle do
    cellar :any
    rebuild 2
    sha256 "d52351433e01eaa27e35ac2b1015e4cc97b424a30990b5491078a67c1a35f19a" => :sierra
    sha256 "44de97863f261ada672b34bc9d66e34331a449114d50b7c76134527e6ff0ef9e" => :el_capitan
    sha256 "80cfa970463761a2056c1c080294c59a3b6f6fd8a84276627a38fcf74b045d26" => :yosemite
    sha256 "8c49f91cfd332e092efb8efc3d4b6190029f648b23b47d20a1341b3882566c87" => :mavericks
  end

  option :universal
  option :cxx11
  option "with-php", "Build the PHP extension"
  option "without-python", "Do not build the Python extension"
  option "with-ruby", "Build the ruby extension"

  depends_on "swig" => :build if build.with?("python") || build.with?("ruby")

  fails_with :llvm

  def install
    ENV.universal_binary if build.universal?
    ENV.cxx11 if build.cxx11?

    # https://trac.osgeo.org/geos/ticket/771
    inreplace "configure" do |s|
      s.gsub! /PYTHON_CPPFLAGS=.*/, %(PYTHON_CPPFLAGS="#{`python-config --includes`.strip}")
      s.gsub! /PYTHON_LDFLAGS=.*/, %(PYTHON_LDFLAGS="-Wl,-undefined,dynamic_lookup")
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
