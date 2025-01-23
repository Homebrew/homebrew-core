class Lutok < Formula
  desc "Lightweight C++ API for Lua"
  homepage "https://github.com/freebsd/lutok"
  url "https://github.com/freebsd/lutok/releases/download/lutok-0.6/lutok-0.6.tar.gz"
  sha256 "e4832908d5dfa203860c7a301109cf1daae3456d0beb54d6e70da252e51f6948"
  license "BSD-3-Clause"

  # Upstream creates releases that use a stable tag (e.g., `v1.2.3`) but are
  # labeled as "pre-release" on GitHub before the version is released, so it's
  # necessary to use the `GithubLatest` strategy.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "d0d41057b9104a544afc9bb4eab0dd8a4accd776df7aaa6fb2d0523ea3e7d2a2"
    sha256 cellar: :any,                 arm64_sonoma:  "2aae7b3e3de1ab6b5282fe7c92db1ab3c7b44cfeef37ce38af0455903f2c845e"
    sha256 cellar: :any,                 arm64_ventura: "3cd059e623da2f9da14ad52b11cbc004a025c6376532f7891c476d99ec53c1a9"
    sha256 cellar: :any,                 sonoma:        "49b517e8925e63c427c0923f1e13a6ab053fe01e2602f2ff153d9c54b381879e"
    sha256 cellar: :any,                 ventura:       "4429d677c31a56ab9624aa3def949d8a9debf8a84ce6ba1489a20fa49e553fa5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "408dd0c0d1895bfac6ea6bd3bb23e1cd9cc26f66fb043b90dbffb9211f8a5ca5"
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
