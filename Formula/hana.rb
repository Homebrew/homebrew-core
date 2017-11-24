class Hana < Formula
  desc "The Boost.Hana C++14 metaprogramming library"
  homepage "https://github.com/boostorg/hana"
  url "https://github.com/boostorg/hana/archive/v1.3.0.tar.gz"
  sha256 "21b0f1a012e924971804f225530aec108c0337110ebd0fe2e34076916fedf4c3"
  head "https://github.com/boostorg/hana.git", :branch => "develop"

  bottle do
    cellar :any_skip_relocation
    sha256 "48ab5f1cddb76daa363e6aa92c16e8d8cfbc02b874b2b3060a9d0d4d8f1ba806" => :high_sierra
    sha256 "1c9329119dc9298abdeacc64b121eb1c96c6818ce5c0b595ac5c9c93e1b1a8a2" => :sierra
    sha256 "1c9329119dc9298abdeacc64b121eb1c96c6818ce5c0b595ac5c9c93e1b1a8a2" => :el_capitan
    sha256 "1c9329119dc9298abdeacc64b121eb1c96c6818ce5c0b595ac5c9c93e1b1a8a2" => :yosemite
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
