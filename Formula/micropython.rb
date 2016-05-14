class Micropython < Formula
  desc "Python implementation for microcontrollers and constrained systems"
  homepage "https://www.micropython.org/"
  url "https://github.com/micropython/micropython/archive/v1.8.tar.gz"
  sha256 "0890bc0250cb212e0bd8aec4b2d4f83428e5a031bbb0bb92882f5c8a3e7a092e"

  bottle do
    cellar :any
    sha256 "941151408d8edd3fc9df1029b946c269bbe85ce5517744ea45df734e10210e89" => :el_capitan
    sha256 "b70712b51d196e23da3c0905a2135b96a22369f3e69cf2f43622b0fe1814fe9e" => :yosemite
    sha256 "33ba0a96ca228e6790db5eca7dd4af16beff334b94d19332322cdd041d9ea5fe" => :mavericks
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
