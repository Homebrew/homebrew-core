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
    sha256 "e363f7a2756735d37a6ab1bb2963512930efd1abff447e2dff67e09185308f8d" => :big_sur
    sha256 "13f14a442c17807aea92f6f10332ae9c59a8056190c5bba5fe2e606140a39198" => :catalina
    sha256 "297e6d7cac984603ae866f31747550d6cfdd473b6c2c83f735e890b4d70c51a2" => :mojave
    sha256 "d34ea2e3316cf9e1afdd89932168285985a1ca5790ae996c6fdba2df11e5621a" => :high_sierra
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
