class Lutok < Formula
  desc "Lightweight C++ API for Lua"
  homepage "https://github.com/freebsd/lutok"
  url "https://github.com/freebsd/lutok/releases/download/lutok-0.6.1/lutok-0.6.1.tar.gz"
  sha256 "509c43c240ba47b8c452b45f3423a416fa91bdfc0341bfb806e0b78f65ce452d"
  license "BSD-3-Clause"

  # Upstream creates releases that use a stable tag (e.g., `v1.2.3`) but are
  # labeled as "pre-release" on GitHub before the version is released, so it's
  # necessary to use the `GithubLatest` strategy.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "8f10d485b0fc059f5a3cd9306bd913bea5b658ac7032afc2e73c9f41e1218a95"
    sha256 cellar: :any,                 arm64_sequoia: "622214005100c49c8927563ebc9643a45ca09e6c2a046a3423f90536bf5c4fd8"
    sha256 cellar: :any,                 arm64_sonoma:  "512239a68c9a297b3058e6218407cc08e3b893255afa64e1e6227ad7d7c54bf5"
    sha256 cellar: :any,                 arm64_ventura: "4c01cfb8ed37128e7ff3319734958694600672c2885a9145f0199ba80f15c418"
    sha256 cellar: :any,                 sonoma:        "5c6514ff4cddd77e9a5899ee67d7639ed0df16fcd40799f4b5a864996fc22be5"
    sha256 cellar: :any,                 ventura:       "6cad6e4dd588227c1cba484e7b3eee3deb60350a50fa7a536359f95a9c804c53"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e5bd35200c2438896dac87fd370af4be0a5f2fee03c23c6659f427523128f048"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "398180c13b8203f6004840922d92ef7d7d1893f7d3f5874580132089083cf5f3"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkgconf" => [:build, :test]

  depends_on "atf"
  depends_on "lua"

  def install
    system "glibtoolize", "--force", "--install"
    system "autoreconf", "--force", "--install", "--verbose"

    system "./configure", "--disable-silent-rules", "--enable-atf", *std_configure_args
    system "make"
    ENV.deparallelize
    system "make", "check"
    system "make", "install"
    system "make", "installcheck"
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
