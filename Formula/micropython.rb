class Micropython < Formula
  desc "Python implementation for microcontrollers and constrained systems"
  homepage "https://www.micropython.org/"
  url "https://github.com/micropython/micropython.git",
      tag:      "v1.19.1",
      revision: "9b486340da22931cde82872f79e1c34db959548b"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "e7fd34409baf3ae9294b4955ac01ef03f8c6e9694d8b8da1df33931b5571e56c"
    sha256 cellar: :any,                 arm64_big_sur:  "6af82d621b4ada013f9a67e350ffa3d8d9778790fb52e43c9bcc3976537d2ff3"
    sha256 cellar: :any,                 monterey:       "b7bfacd192d122d6d425eb4c9b99f7ddb094d9d8802a9966b168eee839a0a514"
    sha256 cellar: :any,                 big_sur:        "07388c9d6c41a2b848b7b8408dbb92a547ab8420c09d25ad353a6698287cc0a8"
    sha256 cellar: :any,                 catalina:       "1f3b7891caa5737bb035e680c0a13186bb9e97c1717db959145bab347ad97bec"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cf8248af0e360223b5cadd07d567f3d443f9aa917e825ee2c94407b3ba6a6d19"
  end

  depends_on "pkg-config" => :build
  depends_on "libffi" # Requires libffi v3 closure API; macOS version is too old
  depends_on "python@3.10" # Requires python3 executable

  def install
    # Build mpy-cross before building the rest of micropython. Build process expects executable at
    # path buildpath/"mpy-cross/mpy-cross", so build it and leave it here for now, install later.
    cd "mpy-cross" do
      system "make"
    end

    cd "ports/unix" do
      system "make", "axtls"
      system "make", "install", "PREFIX=#{prefix}"
    end

    bin.install "mpy-cross/mpy-cross"
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
