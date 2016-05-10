class Micropython < Formula
  desc "Python implementation for microcontrollers and constrained systems"
  homepage "https://www.micropython.org/"
  url "https://github.com/micropython/micropython/archive/v1.8.tar.gz"
  sha256 "0890bc0250cb212e0bd8aec4b2d4f83428e5a031bbb0bb92882f5c8a3e7a092e"

  bottle do
    cellar :any
    sha256 "811bdee93e7d2c4dfcaed11437b540b3473e6a1e7ccec08b573c2601afb21176" => :el_capitan
    sha256 "b2c3ccfd452ad15f6840dd3efd7706cd7bd19769920467534e23b0ea2107108a" => :yosemite
    sha256 "78c2a5e5280c047e0f8aa1e20cb22f0ee31f41aa7287b718d36c10d80c76ae67" => :mavericks
  end

  depends_on "pkg-config" => :build
  depends_on "libffi" # Requires libffi v3 closure API; OS X version is too old

  def install
    cd "unix" do
      system "make", "install", "PREFIX=#{prefix}", "V=1"
    end
  end

  test do
    # Test the FFI module
    (testpath/"ffi-hello.py").write <<-EOS.undent
      import ffi

      libc = ffi.open("libc.dylib")
      printf = libc.func("v", "printf", "s")
      printf("Hello!\\n")
    EOS

    system "#{bin}/micropython", "ffi-hello.py"
  end
end
