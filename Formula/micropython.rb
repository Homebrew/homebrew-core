class Micropython < Formula
  desc "Python implementation for microcontrollers and constrained systems"
  homepage "https://www.micropython.org/"
  url "https://github.com/micropython/micropython.git",
      tag:      "v1.19.1",
      revision: "9b486340da22931cde82872f79e1c34db959548b"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "202d61b8e3b2a07e745f6214c445a53dd6b51613de50e6e6f66879ba32bcbe43"
    sha256 cellar: :any,                 arm64_big_sur:  "c645b21d1a36addc730fff2f67aa2d93cf0059c00e01ca181f1c2b76c0aaa19b"
    sha256 cellar: :any,                 monterey:       "5ddc56be59b2181c0e00ec6bd8a07cab20c8f5850ce7cba6f9a4f20cf7db129f"
    sha256 cellar: :any,                 big_sur:        "b9cd6bdc42c4a68c3d358a402498d2118c91f22899a5d473098ec002319a0ab8"
    sha256 cellar: :any,                 catalina:       "5711908f6d27270e55c6f910dffa725406f9e2ff62525fb8b4c3868cc87dba2a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e058532cf4fec3310c5b6c81a87e7e00c3feba6701ceb03fd20d82c62bb0c854"
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
