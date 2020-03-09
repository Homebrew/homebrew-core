class Micropython < Formula
  desc "Python implementation for microcontrollers and constrained systems"
  homepage "https://www.micropython.org/"
  url "https://github.com/micropython/micropython.git",
      :tag      => "v1.12",
      :revision => "1f371947309c5ea6023b6d9065415697cbc75578"
  revision 2

  bottle do
    cellar :any
    sha256 "2655a7d3482e975098bf8209e4f10652f6aa0c39403e7bb3515e7b871bb98f2f" => :catalina
    sha256 "f4921ea104c1572b691aab795059303d3453ddc3577e7ce18a0939f95f32abf1" => :mojave
    sha256 "0916661bf272e9132b9ffa8a290416ee59bbda2a07d1f7e229371472e812b53f" => :high_sierra
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
