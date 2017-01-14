class Hana < Formula
  desc "The Boost.Hana C++14 metaprogramming library"
  homepage "https://github.com/boostorg/hana"
  url "https://github.com/boostorg/hana/archive/v1.0.2.tar.gz"
  sha256 "51be7e5d11c4bafa595d7a4ebd90185e19e213fa4de291b74a44acc635e86e95"
  head "https://github.com/boostorg/hana.git", :branch => "develop"

  bottle do
    cellar :any_skip_relocation
    sha256 "45519a9fa2e2150570e23aca82adb53ef242e13e358b968f94caa8fc8bde4628" => :sierra
    sha256 "45519a9fa2e2150570e23aca82adb53ef242e13e358b968f94caa8fc8bde4628" => :el_capitan
    sha256 "45519a9fa2e2150570e23aca82adb53ef242e13e358b968f94caa8fc8bde4628" => :yosemite
  end

  depends_on "cmake" => :build
  depends_on :macos => :yosemite

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<-EOS.undent
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
