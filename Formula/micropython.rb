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
    sha256 "fab7a3acdbaa60a27d55130096af91d1573b384150ea225c5cfe5a3ae45f5c31" => :big_sur
    sha256 "593be38355167b300f1ccd41747e376450bbdea12e6e2abf9f299babd627bd54" => :catalina
    sha256 "84ca89452928c450a8e93cef50606760cb651ce7ed357d1713a53581d4afb915" => :mojave
    sha256 "f0812daab9555d0f3668463a7327a763639257103925c253923be18faa721a04" => :high_sierra
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
