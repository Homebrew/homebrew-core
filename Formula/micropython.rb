class Micropython < Formula
  desc "Python implementation for microcontrollers and constrained systems"
  homepage "https://www.micropython.org/"
  url "https://github.com/micropython/micropython.git",
      tag:      "v1.18",
      revision: "da4b38e7562dfa451917f9d7f344a7f26de8c7bd"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "e1b6410da16a3cf7ce27b90ecf0fc3c9fc4fdd0d2db6c96de2f3b192502f62f0"
    sha256 cellar: :any,                 arm64_big_sur:  "e35e1113d9a508c3f5d3b6d17dc94c3d3c35f8fd263890cf70b1ca6b1ed330a9"
    sha256 cellar: :any,                 monterey:       "4d304b8993aa666d8019578da160df127c35369a38152fc691e447182a68231a"
    sha256 cellar: :any,                 big_sur:        "248748849f31c85197df675a1c94ca76acaae87c268732f7ee3450857b63ef1f"
    sha256 cellar: :any,                 catalina:       "64c4f4ed7fccf9ed5f640b6d4c7207a242accb7d982689e1bd3325927587109c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5842f54c8aed4df79ada0ed45df223887aa666e20ff93264fe054d531276c207"
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
