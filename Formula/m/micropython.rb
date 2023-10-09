class Micropython < Formula
  desc "Python implementation for microcontrollers and constrained systems"
  homepage "https://www.micropython.org/"
  url "https://github.com/micropython/micropython/releases/download/v1.21.0/micropython-1.21.0.zip"
  sha256 "12521faacc7191353f2739267bd9fd2a5e60ea04fb47df74f8e22b6bf59ba967"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "6d28868290559a5ce923e725bb12a4a7bc44093bf1a5b51bc7588ed6aa11719a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "75322763fdae33e9f16116201010cc6a5ae67577d4865017524d43eb3ad6b25e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f57add74a33a8f19660e17ad58ae9d8067b6655dce66fa5b76a7a01e49359925"
    sha256 cellar: :any_skip_relocation, sonoma:         "45d37b4699cdff3ae0bbea5a826b21ac70782a5913782b478147c2035c0b431a"
    sha256 cellar: :any_skip_relocation, ventura:        "f6567a1c40536f5a399ae90e7518bf7b8c0491c6803e9b7d5427e293687b2394"
    sha256 cellar: :any_skip_relocation, monterey:       "d2ae79f8009e32b5ebe774ab6823b75e3d636e1ec884ccef365d319faf7e7928"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dbf7898fabb5acb1c10f2adfcd61006d53090d5c95602c673cc1048225fd63be"
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
