class Hana < Formula
  desc "The Boost.Hana C++14 metaprogramming library"
  homepage "https://github.com/boostorg/hana"
  url "https://github.com/boostorg/hana/archive/v1.6.0.tar.gz"
  sha256 "4238f1a132c783b0013f2f6757370ff0ac2b28fc0c8b862de9d5fb296de5b1cb"
  head "https://github.com/boostorg/hana.git", :branch => "develop"

  bottle do
    cellar :any_skip_relocation
    sha256 "e8206af143a0b9b727527dfce2864f485318cc74bd4ec4501ecab6c5243814d3" => :catalina
    sha256 "e3d3fe00a72dd5539b005a84efe3a02d38f56a55dbee0177d3a5415cb8fbcab3" => :mojave
    sha256 "e3d3fe00a72dd5539b005a84efe3a02d38f56a55dbee0177d3a5415cb8fbcab3" => :high_sierra
    sha256 "182be636044ecd0d1df1ffee2d97920a61b35546fe0e8f7e02453164db2456c8" => :sierra
  end

  depends_on "cmake" => :build
  depends_on :macos => :yosemite

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <boost/hana.hpp>

      constexpr auto xs = boost::hana::make_tuple(1, '2', 3.3);
      static_assert(xs[boost::hana::size_c<0>] == 1, "");
      static_assert(xs[boost::hana::size_c<1>] == '2', "");
      static_assert(xs[boost::hana::size_c<2>] == 3.3, "");

      int main() { }
    EOS

    system ENV.cxx, "test.cpp", "-std=c++1y", "-I#{include}", "-otest", *ENV.cppflags
    system "./test"
  end
end
