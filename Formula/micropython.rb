class Micropython < Formula
  desc "Python implementation for microcontrollers and constrained systems"
  homepage "https://www.micropython.org/"
  url "https://github.com/micropython/micropython.git",
      tag:      "v1.17",
      revision: "7c54b6428058a236b8a48c93c255948ece7e718b"
  license "MIT"
  revision 1

  bottle do
    sha256 cellar: :any,                 arm64_big_sur: "535d37a459fd0cc2215c08619c6addbabd62a0bc83cff8d67e57ae26dfe6de71"
    sha256 cellar: :any,                 big_sur:       "3ce56be1ad505370a05f9a4790aaa123579bcf04c80c4126f1454f11c24d7911"
    sha256 cellar: :any,                 catalina:      "1af7b2d77c6e5ead11ec045ebc49eaa24c5d27e3bbe7d6758c84976912261782"
    sha256 cellar: :any,                 mojave:        "7c60328a3a2fb5ab5a1ae55579aabef88a34d82e6c6beb3a41f2c80f39a154b3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d6c3f29354203e57ccf4ec83a1796fdc52b642a34509a3d7408dfb620e23e201"
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
