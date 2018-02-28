class Hana < Formula
  desc "The Boost.Hana C++14 metaprogramming library"
  homepage "https://github.com/boostorg/hana"
  url "https://github.com/boostorg/hana/archive/v1.4.0.tar.gz"
  sha256 "2e2752fa499be280723c51d9fc9e117cdbd6368b2b206de1f240cf10a5e5b2a6"
  head "https://github.com/boostorg/hana.git", :branch => "develop"

  bottle do
    cellar :any_skip_relocation
    sha256 "94d9f585e1b21bb9926634a95a5ddecefd31b20c07aea60faf0a0308109e2449" => :high_sierra
    sha256 "94d9f585e1b21bb9926634a95a5ddecefd31b20c07aea60faf0a0308109e2449" => :sierra
    sha256 "94d9f585e1b21bb9926634a95a5ddecefd31b20c07aea60faf0a0308109e2449" => :el_capitan
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
