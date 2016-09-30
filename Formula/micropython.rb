class Micropython < Formula
  desc "Python implementation for microcontrollers and constrained systems"
  homepage "https://www.micropython.org/"
  url "https://github.com/micropython/micropython.git",
    :tag => "v1.8.4",
    :revision => "3611dcc260cef08eaa497cea4e3ca17977848b6c"

  bottle do
    cellar :any
    sha256 "15d484420ea9077d47646c65f4dbca8aa02f892a60365136ce1a2a98c5040062" => :sierra
    sha256 "94d7600c5c434d700005dbfd7db94482fe5f1adf577c45d54e0968e2125d0d43" => :el_capitan
    sha256 "67e265ff6255c73294802e113b3cf51bc8d9859033297a62728a1637776be3cc" => :yosemite
    sha256 "d4387ba44d795547b8253b9e5131c1cb700a69b50b2b9609452ac93c475b3c4a" => :mavericks
  end

  depends_on "pkg-config" => :build
  depends_on "libffi" # Requires libffi v3 closure API; OS X version is too old

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
