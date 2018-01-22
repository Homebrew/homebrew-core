class Micropython < Formula
  desc "Python implementation for microcontrollers and constrained systems"
  homepage "https://www.micropython.org/"
  url "https://github.com/micropython/micropython.git",
      :tag => "v1.9.3",
      :revision => "fe45d78b1edd6d2202c3544797885cb0b12d4f03"
  revision 1

  bottle do
    cellar :any
    sha256 "82a2f96e85c1d9899b6b4c316d9ead47027fb55e038d315d7c55afa081d67a58" => :high_sierra
    sha256 "84624d68acfdac350881b703c4c719cd13cc9501bd06bf876ecd7551d1f71b92" => :sierra
    sha256 "b16e8e3acbd1271f6449e19e60ea10a0c0c54245937cf95caec322d7a2671f9f" => :el_capitan
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
