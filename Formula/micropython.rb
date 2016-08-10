class Micropython < Formula
  desc "Python implementation for microcontrollers and constrained systems"
  homepage "https://www.micropython.org/"
  url "https://github.com/micropython/micropython.git",
    :tag => "v1.8.3",
    :revision => "e4e4526954f8bcd88ceb21fe789963bfa710fa4f"

  bottle do
    cellar :any
    sha256 "22bb7aa6e7ad4741e8c1c38e0d5cc0ddfcce844fbf0ac339b7a689a8e776cfdb" => :el_capitan
    sha256 "7d85b3a89e6e3c817369bfceee6758d759b71e7ae4e4e04b6182219ab470aaa2" => :yosemite
    sha256 "6ce0f46a7376b9552827d17db92710b485ffb430a0e7e88258593605b384dd35" => :mavericks
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
