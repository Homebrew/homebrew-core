class Micropython < Formula
  desc "Python implementation for microcontrollers and constrained systems"
  homepage "https://www.micropython.org/"
  url "https://github.com/micropython/micropython.git",
      tag:      "v1.15",
      revision: "321d1897c34f16243edf2c94913d7cf877a013d1"
  license "MIT"

  bottle do
    sha256 cellar: :any, big_sur:  "ae273ed59589c3dadf5632aa03246b51960c2ff6d84b73ba34fdcafff79c8e7d"
    sha256 cellar: :any, catalina: "103263d0c625e3fa84337be724a25172c4d95b21bfdfb99b806b75c60ca86df9"
    sha256 cellar: :any, mojave:   "503609fd1033dbdd0e48be4625cf17ccac547912b4f8b02eacff5aab6c43fde5"
  end

  depends_on "pkg-config" => :build
  depends_on "libffi" # Requires libffi v3 closure API; macOS version is too old
  depends_on "python@3.9" # Requires python3 executable

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
    lib_version = nil

    on_linux do
      lib_version = "6"
    end

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
