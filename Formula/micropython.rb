class Micropython < Formula
  desc "Python implementation for microcontrollers and constrained systems"
  homepage "https://www.micropython.org/"
  url "https://github.com/micropython/micropython.git",
      tag:      "v1.17",
      revision: "7c54b6428058a236b8a48c93c255948ece7e718b"
  license "MIT"
  revision 2

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "958c9afb00970ba7480f7463ea9632ea2d8ea0980f2abb431371299ec36cdd83"
    sha256 cellar: :any,                 arm64_big_sur:  "677377aa0c47310b587970b0daff9ba29b987ebd4b8472ab5285d8e8cb15e7ff"
    sha256 cellar: :any,                 monterey:       "17ff3dd17107b974807eaa8ad14194063fb2069a32038a15a23e1a9cec7c77d6"
    sha256 cellar: :any,                 big_sur:        "395c3694341235f8e3eeae947a9bd2692bbebfb7043d4b07f52d3dd211e1da17"
    sha256 cellar: :any,                 catalina:       "ff82df0fd5a96052d8bfc7a0f114fb1f454c742ce6b4aedaebcba62cc24d97a6"
    sha256 cellar: :any,                 mojave:         "8dc695ae73f1c6b8d508ae63af06def4c706d14ca9e007c5b3fce787c7f17ee3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8327f00b5e66af095f7299ae1fa34e9679dc9ae32426b052efa99e080d5db490"
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
