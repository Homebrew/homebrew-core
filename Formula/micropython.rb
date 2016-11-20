class Micropython < Formula
  desc "Python implementation for microcontrollers and constrained systems"
  homepage "https://www.micropython.org/"
  url "https://github.com/micropython/micropython.git",
    :tag => "v1.8.6",
    :revision => "5a1d63fc14dae788f705403a43c2d8639b7dd9cd"

  bottle do
    cellar :any
    sha256 "1fa57e4d571f8a36358a28318a4f56d78783ff4ddb7487c89d826aa30e3fa0b3" => :sierra
    sha256 "484eb47c223be42fdad80de0e946c95e0611b1b6cff47cb798153903a9823e13" => :el_capitan
    sha256 "81a4250412985d5a3a47f790e8bf8a33706071217c183d14f63930555ca580a2" => :yosemite
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
