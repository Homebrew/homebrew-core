class Micropython < Formula
  desc "Python implementation for microcontrollers and constrained systems"
  homepage "https://www.micropython.org/"
  url "https://github.com/micropython/micropython/releases/download/v1.20.0/micropython-1.20.0.zip"
  sha256 "6a2ce86e372ee8c5b9310778fff7fca1daa580afa28ea755f1a303675a8612b7"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0fe34aa684c31925b2408db17f07770e30553f8ee710974ca46bcd8d9c92de91"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0e00554ee1669f08562cf5e9ac399031f95a165e1b536f60635ddcb079b7f203"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6b6109e0fff249f845059b7e4d18ce7756151882d1237d115f4313e1a595553e"
    sha256 cellar: :any_skip_relocation, ventura:        "b3c52db1a033a9fe6a4404298a0020e7694ea0a3380740e30a5ad00ee273b626"
    sha256 cellar: :any_skip_relocation, monterey:       "7c7b22c8d84550cbf337cad903f3540c4994dada2cf18497ad09efe87e85895f"
    sha256 cellar: :any_skip_relocation, big_sur:        "2cf2de3cde04394ae7db07cf2369f24a243037ace7bab2f9a9c29ce2da4a1759"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "26b2b9c760b87ffcf3046256e40a6b566c25ab43ea2500218ff400777c5632b0"
  end

  depends_on "pkg-config" => :build
  depends_on "python@3.11" # Requires python3 executable

  uses_from_macos "libffi", since: :catalina # Requires libffi v3 closure API

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
