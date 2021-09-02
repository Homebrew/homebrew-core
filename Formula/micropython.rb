class Micropython < Formula
  desc "Python implementation for microcontrollers and constrained systems"
  homepage "https://www.micropython.org/"
  url "https://github.com/micropython/micropython.git",
      tag:      "v1.17",
      revision: "7c54b6428058a236b8a48c93c255948ece7e718b"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_big_sur: "e9fa695e69a3d93b60289e8e4698cb99cf909f69af7b62565a8a16d32c9e40c5"
    sha256 cellar: :any,                 big_sur:       "dd7d21cbe5e6eeaf4c898269dcbbddf7f77470bc6cc30cd14a1ab710f0f07d06"
    sha256 cellar: :any,                 catalina:      "4db83fc025b9bf91be5ee37b4093b66ccf6e796c73e13cfdb4ac03ebedda489f"
    sha256 cellar: :any,                 mojave:        "3bc0210fa2b0f6de0218db02a596e385d57850cd5b8b84f92b3af0d93711876c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c0a2ca49e0b12e56a45fa5f98555a4bb35fb882f392aa1246db91be60de3e792"
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
