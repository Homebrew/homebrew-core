class Micropython < Formula
  desc "Python implementation for microcontrollers and constrained systems"
  homepage "https://www.micropython.org/"
  url "https://github.com/micropython/micropython.git",
    :tag => "v1.8.6",
    :revision => "5a1d63fc14dae788f705403a43c2d8639b7dd9cd"

  bottle do
    cellar :any
    sha256 "9528ec405ab9d89bf55fb5cca1649aa9244cc4b4b3e20c9e658eb059f21c6989" => :sierra
    sha256 "90db704d626d50117c49819e4d51a265fcf9eb758f849857bde4215f205d748a" => :el_capitan
    sha256 "9f66d35b4033f76831ceb6091a8bc4fc3529d381762e600ef3c610cebc13adc3" => :yosemite
  end

  depends_on "pkg-config" => :build
  depends_on "libffi" # Requires libffi v3 closure API; macOS version is too old

  def install
    cd "unix" do
      system "make", "axtls"
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

    system bin/"micropython", "ffi-hello.py"
  end
end
