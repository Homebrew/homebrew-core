class Micropython < Formula
  desc "Python implementation for microcontrollers and constrained systems"
  homepage "https://www.micropython.org/"
  url "https://github.com/micropython/micropython.git",
      tag:      "v1.13",
      revision: "b0932fcf2e2f9a81abf7737ed4b2573bd9ad4a49"
  license "MIT"
  revision 1

  bottle do
    cellar :any
    sha256 "a1d3fffd4edf9863ab61e1db6cf32919d9f8a862e3a99a26ec0585342d894090" => :catalina
    sha256 "3cec76e6155aea17f19d6861fbfd84e20e0f76aacd0ee8d4bcd04096f8b8c9fc" => :mojave
    sha256 "c1735b727c4f2fae37d233dd284e99d86b44f5dbfd75e0938a739b5ae1713d72" => :high_sierra
  end

  depends_on "pkg-config" => :build
  depends_on "libffi" # Requires libffi v3 closure API; macOS version is too old
  depends_on "python@3.9" # Requires python3 executable

  def install
    # Build mpy-cross before building the rest of micropython. Build process expects executable at
    # path buildpath/"mpy-cross/mpy-cross", so build it and leave it here for now, install later.
    cd "mpy-cross" do
      system "make"
    end

    cd "ports/unix" do
      system "make", "axtls"
      system "make", "install", "PREFIX=#{prefix}"
    end

    bin.install "mpy-cross/mpy-cross"
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
