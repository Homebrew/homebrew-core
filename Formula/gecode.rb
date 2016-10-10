class Gecode < Formula
  desc "Toolkit for developing constraint-based systems and applications"
  homepage "http://www.gecode.org/"
  url "http://www.gecode.org/download/gecode-4.4.0.tar.gz"
  sha256 "b45783cc8d0d5dbbd3385a263a2199e6ad7f9a286e92607de81aa0c1105769cb"

  bottle do
    cellar :any
    sha256 "4aa4d7b036da2e4976b469fc6b7addf44778a24fcc85d9fdec80e50d28dd50c8" => :el_capitan
    sha256 "4df88b3f67a4d188f00883f182f3893b9df99b90637635abf18441ebfbeb0c9c" => :yosemite
    sha256 "b48b0a8755542484f5eeb5647e41db0824cfb769060c28c118df6267fa98aaab" => :mavericks
    sha256 "a6cf500df618c42f0668bb227c090e6c1d3d3369c8b4537220d3deb78d5f8286" => :mountain_lion
  end

  depends_on "qt5" => :optional

  def install
    args = %W[
      --prefix=#{prefix}
      --disable-examples
    ]
    ENV.append "CXXFLAGS", "-std=c++11"
    if build.with? "qt5"
      args << "--enable-qt"
      ENV.append_path "PKG_CONFIG_PATH", "#{HOMEBREW_PREFIX}/opt/qt5/lib/pkgconfig"
    else
      args << "--disable-qt"
    end
    system "./configure", *args
    system "make", "install"
  end
end
