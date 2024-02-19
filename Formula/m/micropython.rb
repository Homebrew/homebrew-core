class Micropython < Formula
  desc "Python implementation for microcontrollers and constrained systems"
  homepage "https://www.micropython.org/"
  url "https://github.com/micropython/micropython/releases/download/v1.22.0/micropython-1.22.0.zip"
  sha256 "f85602c71221a60128c80879b5eec0be0570b0e091f8cb8a8fb9181b0fabb91a"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "97362c648c3649d038981625f7f3f3553c3ab9bf24aefedf785126182458f6d3"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a02c2ca82e1757dec27b3c8bfdaac97efbcd02ed04be1b453378ef4fed87ccd8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "72ada73e6f3908934bb6daa1eb46c2918354dadd4a9bf41f949a886ca74aaa76"
    sha256 cellar: :any_skip_relocation, sonoma:         "75165221df6b2ede8c42472f0f4e1936e31bcb3a8f64752611ae629a4bf28af7"
    sha256 cellar: :any_skip_relocation, ventura:        "e6b991e680632b52f332c68f10ad7d0b5820637888643498ff5d02f63f0fbb4f"
    sha256 cellar: :any_skip_relocation, monterey:       "4d5a068dded76c2d723c0d9aeba5a8335b4dae053e0936d4acc41d8fa6a3e1be"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3e13995fe52a6131e96faa8bd2def293d5cb30c7576596895805f3728a9ea906"
  end

  depends_on "pkg-config" => :build
  uses_from_macos "libffi", since: :catalina
  uses_from_macos "python" # Requires libffi v3 closure API

  def install
    system "make", "-C", "ports/unix", "install", "PREFIX=#{prefix}"
    bin.install "mpy-cross/build/mpy-cross"
  end

  test do
    lib_version = "6" if OS.linux?

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
