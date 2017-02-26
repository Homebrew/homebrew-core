class Hana < Formula
  desc "The Boost.Hana C++14 metaprogramming library"
  homepage "https://github.com/boostorg/hana"
  url "https://github.com/boostorg/hana/archive/v1.1.0.tar.gz"
  sha256 "bb33358842300524fbac61710850a349771ae125fba16f3c39a047a15c9bcfb9"
  head "https://github.com/boostorg/hana.git", :branch => "develop"

  bottle do
    cellar :any_skip_relocation
    sha256 "d3648fae565ddce63d113bddaefd639bf1e52618e5be45e88b6ba7cf529d38ec" => :sierra
    sha256 "822eef7d44eb999289d344c9d8b51c93106f0ede237b065d54ac0c3451412fbc" => :el_capitan
    sha256 "822eef7d44eb999289d344c9d8b51c93106f0ede237b065d54ac0c3451412fbc" => :yosemite
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
