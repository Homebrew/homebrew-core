class Micropython < Formula
  desc "Python implementation for microcontrollers and constrained systems"
  homepage "https://www.micropython.org/"
  url "https://github.com/micropython/micropython.git",
    :tag => "v1.8.3",
    :revision => "e4e4526954f8bcd88ceb21fe789963bfa710fa4f"

  bottle do
    cellar :any
    sha256 "ac99784b6f3df968eb53ce0ddaffa6f84f4764ebc7a3c97be351fab91504609a" => :el_capitan
    sha256 "c476dbb419511d2a0684d6f6cf9fd04f7dc1469e7458f5a63c6ebe18a20636df" => :yosemite
    sha256 "33bd37bff62718901df74e5dcbebee229492c9dcad686e89af0c7d999730285e" => :mavericks
  end

  depends_on "pkg-config" => :build
  depends_on "libffi" # Requires libffi v3 closure API; OS X version is too old

  # Fix build failure with errors such as "expected parameter declarator"
  # upstream commit "mpconfigport.h: don't include stdio.h if macOS"
  patch do
    url "https://github.com/micropython/micropython/commit/4e36dd57.patch"
    sha256 "7406e65d54f5a0759894d60832088e71b1d090dfc611c3f0de41dbaa19734dea"
  end

  def install
    cd "unix" do
      system "make", "axtls"
      system "make", "install", "PREFIX=#{prefix}", "V=1"
    end
  end

  test do
    # Test the FFI module
    (testpath/"ffi-hello.py").write <<-EOS.undent
      import ffi

      libc = ffi.open("libc.dylib")
      printf = libc.func("v", "printf", "s")
      printf("Hello!\\n")
    EOS

    system bin/"micropython", "ffi-hello.py"
  end
end
