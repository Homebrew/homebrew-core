class Micropython < Formula
  desc "Python implementation for microcontrollers and constrained systems"
  homepage "https://www.micropython.org/"
  url "https://github.com/micropython/micropython.git",
    :tag => "v1.8.2",
    :revision => "1459a8d5c9b29c78da2cf5c7cf3c37ab03b34b8e"

  bottle do
    cellar :any
    sha256 "22bb7aa6e7ad4741e8c1c38e0d5cc0ddfcce844fbf0ac339b7a689a8e776cfdb" => :el_capitan
    sha256 "7d85b3a89e6e3c817369bfceee6758d759b71e7ae4e4e04b6182219ab470aaa2" => :yosemite
    sha256 "6ce0f46a7376b9552827d17db92710b485ffb430a0e7e88258593605b384dd35" => :mavericks
  end

  depends_on "pkg-config" => :build
  depends_on "libffi" # Requires libffi v3 closure API; OS X version is too old

  def install
    # Equivalent to upstream fix for "fatal error: 'endian.h' file not found"
    # https://github.com/pfalcon/axtls/commit/3e1b4909a2ddd76c5797f241f2ed56ef699a7e91
    # Should be removed at the next version bump (MicroPython > 1.8.2)
    inreplace "lib/axtls/crypto/os_int.h", "#include <endian.h>", ""

    cd "unix" do
      # Works around undefined symbol error for "mp_thread_get_state"
      # Reported 11 Jul 2016: https://github.com/micropython/micropython/issues/2233
      inreplace "mpconfigport.mk", "MICROPY_PY_THREAD = 1",
                                   "MICROPY_PY_THREAD = 0"
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
