class Micropython < Formula
  desc "Python implementation for microcontrollers and constrained systems"
  homepage "https://www.micropython.org/"
  url "https://github.com/micropython/micropython.git",
      tag:      "v1.12",
      revision: "1f371947309c5ea6023b6d9065415697cbc75578"
  license "MIT"
  revision 2

  bottle do
    cellar :any
    sha256 "af98b434dd38d24a28541b3bdc168a689b914b425aa80a6bf384c18862ed3737" => :catalina
    sha256 "dff6248820013f3f31408252de971418ac26f6eacd20791c6eaeb9527ea552f2" => :mojave
    sha256 "19800fe474da81062c005732c1dd6c3e66e6a2a8e04f38a4a69ce8513808895c" => :high_sierra
  end

  depends_on "pkg-config" => :build
  depends_on "libffi" # Requires libffi v3 closure API; macOS version is too old
  depends_on "python@3.8" # Requires python3 executable

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
