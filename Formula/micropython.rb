class Micropython < Formula
  desc "Python implementation for microcontrollers and constrained systems"
  homepage "https://www.micropython.org/"
  url "https://github.com/micropython/micropython.git",
      :tag => "v1.9.3",
      :revision => "fe45d78b1edd6d2202c3544797885cb0b12d4f03"
  revision 1

  bottle do
    cellar :any
    sha256 "e071d65ec654f528a26cf020a94072b17aeaf08385115d524e6c6139d16b6ab3" => :high_sierra
    sha256 "14cd46105046e82ede775f2fd1eab21dbb4a8a7506361f5de98845791b56b106" => :sierra
    sha256 "a485feb6b215857d7870d56c21bceab55e16bfd85ad48d296f3a79842388d7e8" => :el_capitan
  end

  depends_on "pkg-config" => :build
  depends_on "libffi" # Requires libffi v3 closure API; macOS version is too old

  def install
    cd "ports/unix" do
      system "make", "axtls"
      system "make", "install", "PREFIX=#{prefix}"
    end

    cd "mpy-cross" do
      system "make"
      bin.install "mpy-cross"
    end
  end

  test do
    # Test the FFI module
    (testpath/"ffi-hello.py").write <<~EOS
      import ffi

      libc = ffi.open("libc.dylib")
      printf = libc.func("v", "printf", "s")
      printf("Hello!\\n")
    EOS

    system bin/"mpy-cross", "ffi-hello.py"
    system bin/"micropython", "ffi-hello.py"
  end
end
