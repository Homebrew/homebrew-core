class Micropython < Formula
  desc "Python implementation for microcontrollers and constrained systems"
  homepage "https://www.micropython.org/"
  url "https://github.com/micropython/micropython.git",
      :tag => "v1.9.1",
      :revision => "869cdcfdfc860b1177baf9b0f8818915ba54f3f5"

  bottle do
    cellar :any
    sha256 "642af2b16237813729a3dbf23b5021ac7aeb17abb725f26abf9ef94170c42db9" => :sierra
    sha256 "5d9d62636bb479df461d19d3bd6de070acd658873f6cdae6646357e7e3bc9721" => :el_capitan
    sha256 "9f18594a8d8884279398fa5ceed203ce801d5524f3a478fdd5fa354ad7cf1aa2" => :yosemite
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
