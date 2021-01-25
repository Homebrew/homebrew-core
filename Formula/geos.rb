class Geos < Formula
  desc "Geometry Engine"
  homepage "https://trac.osgeo.org/geos"
  url "https://download.osgeo.org/geos/geos-3.9.0.tar.bz2"
  sha256 "bd8082cf12f45f27630193c78bdb5a3cba847b81e72b20268356c2a4fc065269"
  license "LGPL-2.1"

  livecheck do
    url "https://download.osgeo.org/geos/"
    regex(/href=.*?geos[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    cellar :any
    sha256 "af956efbf37bc8b6462e1ad18f19e5d4a42a1b59e78f6a01901244899f8f0cba" => :big_sur
    sha256 "c0ed29477cb947d1c5b128e05bde75b48a5bac0e96f48516941c19feaa488607" => :arm64_big_sur
    sha256 "2dba43e2cb2dfacb24c6017c47c8f14c8433db0865e973d025e40924d8fc06e6" => :catalina
    sha256 "e460db9c6729fc8091e51e693cab84dcbb1ed046bc20e0edb54069ff39daf2b9" => :mojave
  end

  depends_on "swig" => :build
  depends_on "python@3.9"

  def install
    args = %W[
      --disable-dependency-tracking
      --prefix=#{prefix}
      --enable-python
      PYTHON=#{Formula["python@3.9"].opt_bin}/python3
    ]
    args << "--disable-inline" if Hardware::CPU.arm?

    system "./configure", *args
    system "make", "install"
  end

  test do
    system "#{bin}/geos-config", "--libs"
  end
end
