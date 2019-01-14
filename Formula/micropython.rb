class Micropython < Formula
  desc "Python implementation for microcontrollers and constrained systems"
  homepage "https://www.micropython.org/"
  url "https://github.com/micropython/micropython.git",
      :tag      => "v1.9.4",
      :revision => "421b84af9968e582f324899934f52b3df60381ee"

  bottle do
    cellar :any
    sha256 "be2d76d5b19e0c2cb18734141fe1b09fbb79f1a60989789cefd76aabc6963c3e" => :mojave
    sha256 "4c4b34c14c357ac012cc5a140fb4d0e1cee912852911a8796b3815cc099e98b2" => :high_sierra
    sha256 "e864ea4c00070477b60ed09d0406d6609e1b79fe440c8cdf84b35a0c78e82bce" => :sierra
    sha256 "e7e84a7479414bf94fc8bd739bd97bf4c9996a757571e648b7d2ef04e70ccb04" => :el_capitan
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
