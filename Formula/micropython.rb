class Micropython < Formula
  desc "Python implementation for microcontrollers and constrained systems"
  homepage "https://www.micropython.org/"
  url "https://github.com/micropython/micropython.git",
      :tag => "v1.9.1",
      :revision => "869cdcfdfc860b1177baf9b0f8818915ba54f3f5"

  bottle do
    cellar :any
    sha256 "a02e1be24663486a3e1743fcef37e87b90be0a6e237522ccd86f0e1828ec4aff" => :sierra
    sha256 "e45945e5b82a041fb61f70b87d9cafbe6ce86fecc997fbbc8d2b7402de51eaef" => :el_capitan
    sha256 "88ff47c47c48e0b8d9d37406989c8e8e2fe5be0d88edf7ad79d646c9a6e6822c" => :yosemite
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
