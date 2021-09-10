class Micropython < Formula
  desc "Python implementation for microcontrollers and constrained systems"
  homepage "https://www.micropython.org/"
  url "https://github.com/micropython/micropython.git",
      tag:      "v1.17",
      revision: "7c54b6428058a236b8a48c93c255948ece7e718b"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_big_sur: "895f218115da8beafc09bb3f6d12054f768130f9cd277ceea8ef80e74ea5926f"
    sha256 cellar: :any,                 big_sur:       "a4edf2dea151e9d75df897e28a8bbe79ffaa9d28e288a958ce963ca062eca4d9"
    sha256 cellar: :any,                 catalina:      "4bdae46a88ef9337b619931ad80578189fec96f955cd7c0d4736498db208a96f"
    sha256 cellar: :any,                 mojave:        "ac856567d0576d050da683f656ab0cd4d04f7ca5fa51eb5905cf948e6c2ec504"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "49292f085f5962dc6539d22c8bdddfb2255aa720b6f48cecdce5266f5a94bb63"
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
    lib_version = nil

    on_linux do
      lib_version = "6"
    end

    # Test the FFI module
    (testpath/"ffi-hello.py").write <<~EOS
      import ffi

      libc = ffi.open("#{shared_library("libc", lib_version)}")
      printf = libc.func("v", "printf", "s")
      printf("Hello!\\n")
    EOS

    system bin/"mpy-cross", "ffi-hello.py"
    system bin/"micropython", "ffi-hello.py"
  end
end
