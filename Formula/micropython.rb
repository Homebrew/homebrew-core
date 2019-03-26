class Micropython < Formula
  desc "Python implementation for microcontrollers and constrained systems"
  homepage "https://www.micropython.org/"
  url "https://github.com/micropython/micropython.git",
      :tag      => "v1.10",
      :revision => "3e25d611ef3185b68558a20057d50b0d18dc67a0"

  bottle do
    cellar :any
    sha256 "c635e90b5127a6101de370032e4ac9230f98a223d3c53d594f9122c8dfd58b01" => :mojave
    sha256 "01611cf99b4623f5157a81ddf16f6b750d71010eead09203f8f7a72d30354fa9" => :high_sierra
    sha256 "54b499d93100baad80a31c32d997b1c97988abdc28d7cad3400f8f811eed4979" => :sierra
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
