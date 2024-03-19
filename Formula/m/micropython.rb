class Micropython < Formula
  desc "Python implementation for microcontrollers and constrained systems"
  homepage "https://www.micropython.org/"
  url "https://github.com/micropython/micropython/releases/download/v1.22.2/micropython-1.22.2.zip"
  sha256 "1eb2200e814f8498a16a99da3840b7dd14b9b18355d1592b84a0ebd65178515d"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c0ba5e81c3a3a257e7e383ff8dd6a8199c22dbe499f01aa7a718c866349aa3cc"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2f54e40879cbe68ed662a30de358238d1ba1caa64cbee02a1ae08336b99b612a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "25bc6e35d7fdc7506f7e8fd06b1c52a6f6ed7fc51165336ff5ce4c15dcc1e9c1"
    sha256 cellar: :any_skip_relocation, sonoma:         "d570c30f2e493a97edca095fe0540256d7f191a76f029116fea98413d0cb0705"
    sha256 cellar: :any_skip_relocation, ventura:        "d389e2d8464195147faa6bb453b22ea76b588b534f709a84f9a9bb8f530755f9"
    sha256 cellar: :any_skip_relocation, monterey:       "302a0405c1da61838a4852945264ba092b3c7244962642f4f6fa933ea31edfa6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "236872f6762d3049c223b727c9fbc22fb5b1cba1c7d481218decd440d9a32f03"
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
