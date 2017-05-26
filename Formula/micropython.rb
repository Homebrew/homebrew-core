class Micropython < Formula
  desc "Python implementation for microcontrollers and constrained systems"
  homepage "https://www.micropython.org/"
  url "https://github.com/micropython/micropython.git",
      :tag => "v1.9",
      :revision => "825460a093a6bcd8fb79119b5f6ee8408f63603b"

  bottle do
    cellar :any
    sha256 "67fc514638513368dfa774f1a72d502ffb61e24a0736c32869a9a1f4ad9737bb" => :sierra
    sha256 "a1f784f6761753470994ed5fea67bfc13b9e8617828caa333a8b450a19875f59" => :el_capitan
    sha256 "ad503b4e7a15dfcb8b151c7225db329697bad3270ee95196e7aeaf74c32b449d" => :yosemite
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
