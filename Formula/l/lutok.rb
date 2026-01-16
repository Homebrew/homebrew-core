class Lutok < Formula
  desc "Lightweight C++ API for Lua"
  homepage "https://github.com/freebsd/lutok"
  url "https://github.com/freebsd/lutok/releases/download/lutok-0.6.2/lutok-0.6.2.tar.gz"
  sha256 "1ef51f3741d28e27b09dfaee61ab432966cff56f50940eca1cbacffc11baa2ad"
  license "BSD-3-Clause"
  head "https://github.com/freebsd/lutok.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "5b5c2b7b65fbf24a1f4ebb2662b41475d9ec0dad5db6a4c0d1f137540390780e"
    sha256 cellar: :any,                 arm64_sequoia: "8dba584b59b9ec5a9711389056ea71ab5237a0857f9a21e09ab7bf7f58eeb6a3"
    sha256 cellar: :any,                 arm64_sonoma:  "4123f23cd62ffdb746f5772d8e7e004b032ffef68fbbb9e02d533e4b0d446ed3"
    sha256 cellar: :any,                 sonoma:        "f6e0c7a0eef0dbefbaa303869d37050ed911fbacecb74270280c058f1470fbf7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "228d1acc93f60bf3e273895f8dd3e2380bb5331b5605adf6312aa5e8c8008568"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9750afbc1c546418d5a6b86128b954ac82c9cf9f05128258ef3be35dcf19ebda"
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
