class Micropython < Formula
  desc "Python implementation for microcontrollers and constrained systems"
  homepage "https://www.micropython.org/"
  url "https://github.com/micropython/micropython.git",
      tag:      "v1.15",
      revision: "321d1897c34f16243edf2c94913d7cf877a013d1"
  license "MIT"

  bottle do
    sha256 cellar: :any, big_sur:  "7189071c553ab2ea57ae669e94eea6a24f3d2f942a95c37a2ffeece24f87b290"
    sha256 cellar: :any, catalina: "85748d870424a6f6d30d2e921e613419f8d46320576d86ca6a563dbe3f8e69ca"
    sha256 cellar: :any, mojave:   "00fe3b2e6e7373ee4528fa536c23352c85a4f8c135da0c7066fd3cabefcd711f"
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
