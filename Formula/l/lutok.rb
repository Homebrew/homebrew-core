class Lutok < Formula
  desc "Lightweight C++ API for Lua"
  homepage "https://github.com/freebsd/lutok"
  url "https://github.com/freebsd/lutok/releases/download/lutok-0.6.2/lutok-0.6.2.tar.gz"
  sha256 "1ef51f3741d28e27b09dfaee61ab432966cff56f50940eca1cbacffc11baa2ad"
  license "BSD-3-Clause"
  revision 1
  head "https://github.com/freebsd/lutok.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "5375d9b2d49d55cda41f53ba11c44a47b6c9fe76e52a5b3592bf48afda9b9871"
    sha256 cellar: :any,                 arm64_sequoia: "cf023d7cb40f5d1a0fbb65a3c937a1bca17828e2e2356960af0a119bfeca6e81"
    sha256 cellar: :any,                 arm64_sonoma:  "02acd0a9b44150ba2297dddee6eb3ca10f244ca63a093e5a655e2cf8eec1fad6"
    sha256 cellar: :any,                 sonoma:        "0f73bf9da21d6a0a923303f03d2ae52373a1885e39eb050ed291e35d33a1934a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6d750bc1a48d2b4b621462e267437c33c32b0305ad4acb72c51900759068f5a5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e216fa951f1f38a59d2a4962c6d58e61ec90ac9d7f27403940cbd9a79c06c4ad"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkgconf" => [:build, :test]

  depends_on "lua"

  def install
    system "glibtoolize", "--force", "--install"
    system "autoreconf", "--force", "--install", "--verbose"

    system "./configure", "--disable-silent-rules", *std_configure_args
    system "make"
    ENV.deparallelize
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<~CPP
      #include <lutok/state.hpp>
      #include <iostream>
      int main() {
          lutok::state lua;
          lua.open_base();
          lua.load_string("print('Hello from Lua')");
          lua.pcall(0, 0, 0);
          return 0;
      }
    CPP

    flags = shell_output("pkgconf --cflags --libs lutok").chomp.split
    system ENV.cxx, "test.cpp", "-std=c++11", "-o", "test", *flags
    system "./test"
  end
end
