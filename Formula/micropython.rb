class Micropython < Formula
  desc "Python implementation for microcontrollers and constrained systems"
  homepage "https://www.micropython.org/"
  url "https://github.com/micropython/micropython.git",
      :tag      => "v1.12",
      :revision => "1f371947309c5ea6023b6d9065415697cbc75578"

  bottle do
    cellar :any
    sha256 "3de4a541b87cacf87d3660b228186f2cbf6aa00259f6bea79cc817a85bd959bb" => :catalina
    sha256 "b19a92f378ff603b4931986730d8845c802feeaa03aebc2ac2b7801845d44f0f" => :mojave
    sha256 "20ee8bff9e4e9dffc421c47de51b15fccf4d824ade2b99cc3ea1ffd1f9ccb6fd" => :high_sierra
  end

  depends_on "pkg-config" => :build
  depends_on "libffi" # Requires libffi v3 closure API; macOS version is too old
  depends_on "python" # Requires python3 executable

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
