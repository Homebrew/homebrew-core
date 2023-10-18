class Micropython < Formula
  desc "Python implementation for microcontrollers and constrained systems"
  homepage "https://www.micropython.org/"
  url "https://github.com/micropython/micropython/releases/download/v1.21.0/micropython-1.21.0.zip"
  sha256 "12521faacc7191353f2739267bd9fd2a5e60ea04fb47df74f8e22b6bf59ba967"
  license "MIT"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c9fd62ecdb0ea872c3cf436ede393a769ec46130afbfd086968a54262507094a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b0af4c546a74f8e57b2f5728dbf3a3bd4c51d0ecd58785546b12206c564f8610"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8e1eeaaf0412ed2c298b61d616a0c342adbf3baab4f6415338595db4645f9210"
    sha256 cellar: :any_skip_relocation, sonoma:         "deae2550a9a5ff7563e9781628741b22e44c9a1430f19f2c988f52cccea3b562"
    sha256 cellar: :any_skip_relocation, ventura:        "961a24d06a5ae270d900bcf50f2a0bf50bcd5f67c34825da76b75f13343bcf9c"
    sha256 cellar: :any_skip_relocation, monterey:       "d5840fe1037dfb479b8fda44363b89a896b229a5d6d75a065fcf250166e25501"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "04705df2381f98f3404316e10468544e5031031fcf533b916bdfa8a32ed956eb"
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
