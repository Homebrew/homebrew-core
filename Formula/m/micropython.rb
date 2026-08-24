class Micropython < Formula
  desc "Python implementation for microcontrollers and constrained systems"
  homepage "https://www.micropython.org/"
  url "https://github.com/micropython/micropython/releases/download/v1.29.0/micropython-1.29.0.tar.xz"
  sha256 "d925a7c664e79a2bdf3dfcb285ba5e2237041cc35a0bd4ee573b6c5711efeca0"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "94590668f87b4e8c68591b0ebaefa7ec7aa739082a66abfc87327fb40e188046"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e753189ff0d5b5b8c23c5d586d466ea195ed0fd54c6ce396791d7da063c657d7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "be511518e1ed503262886c4ed7a50c712b722f0878bd5462ff4bc6d244c7cab8"
    sha256 cellar: :any_skip_relocation, sequoia:       "a4c6635bd2a429043a64ff3416a03cd162c8513eaf45f1edf47d417ded3846b7"
    sha256 cellar: :any_skip_relocation, sonoma:        "c478690e086c6e89447463ab23e7368cb6ef7a41f244dc32b696579289a6452f"
    sha256 cellar: :any,                 arm64_linux:   "5c38fe5e92841b7e294bc1d17e1e37cd1279a3cd0a68215bd1c91b9dbf240831"
    sha256 cellar: :any,                 x86_64_linux:  "7cf32cd611e2cad51408a2daaa974a105868f36e85a3e2c43706a7c6efc9d556"
  end

  depends_on "pkgconf" => :build
  uses_from_macos "libffi"
  uses_from_macos "python" # Requires libffi v3 closure API

  def install
    system "make", "-C", "ports/unix", "install", "PREFIX=#{prefix}"
    bin.install "mpy-cross/build/mpy-cross"
  end

  test do
    lib_version = "6" if OS.linux?

    # Test the FFI module
    (testpath/"ffi-hello.py").write <<~PYTHON
      import ffi

      libc = ffi.open("#{shared_library("libc", lib_version)}")
      printf = libc.func("v", "printf", "s")
      printf("Hello!\\n")
    PYTHON

    system bin/"mpy-cross", "ffi-hello.py"
    system bin/"micropython", "ffi-hello.py"
  end
end
