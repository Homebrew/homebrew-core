class Hana < Formula
  desc "The Boost.Hana C++14 metaprogramming library"
  homepage "https://github.com/boostorg/hana"
  url "https://github.com/boostorg/hana/archive/v1.5.0.tar.gz"
  sha256 "1a797075e823b42454b7a1efe40ec648477bdf748e8cf043a18024c45b41f591"
  head "https://github.com/boostorg/hana.git", :branch => "develop"

  bottle do
    cellar :any_skip_relocation
    sha256 "8ca9c99bacaa652a8792da78418345ab7f84eb3885fffc2c9bec6eb429d3fa25" => :mojave
    sha256 "2508e9dc9d41877be496f2300e9e0660a0060cca0e86aaa216fac58d7e6bac75" => :high_sierra
    sha256 "2508e9dc9d41877be496f2300e9e0660a0060cca0e86aaa216fac58d7e6bac75" => :sierra
    sha256 "2508e9dc9d41877be496f2300e9e0660a0060cca0e86aaa216fac58d7e6bac75" => :el_capitan
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
