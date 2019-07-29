class H3 < Formula
  desc "Hexagonal hierarchical geospatial indexing system"
  homepage "https://uber.github.io/h3/"
  url "https://github.com/uber/h3/archive/v3.5.0.tar.gz"
  sha256 "60a6cf83661909dffa2a9fd02e7b35d7fe5612b066f0f571f66e4bfbc22ec917"

  bottle do
    cellar :any
    sha256 "d16ae178de9da08bafc054d99334ed906b0636a595ea825fb8d001bd24826e18" => :mojave
    sha256 "a7b8019bd60ed630389e01a344e30ae21aec35ca39c8e734e78f5fdaf6b0a891" => :high_sierra
    sha256 "b13a08358eba6b6c70056b16ab20823379af5bdb3bf23f5bac0ecbab1dabf13a" => :sierra
  end

  depends_on "cmake" => :build

  def install
    mkdir "build" do
      system "cmake", "..", "-DBUILD_SHARED_LIBS=YES", *std_cmake_args
      system "make", "install"
    end
  end

  test do
    result = pipe_output("#{bin}/geoToH3 -r 10 --lat 40.689167 --lon -74.044444")
    assert_equal "8a2a1072b59ffff", result.chomp
  end
end
