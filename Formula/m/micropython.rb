class Micropython < Formula
  desc "Python implementation for microcontrollers and constrained systems"
  homepage "https://www.micropython.org/"
  url "https://github.com/micropython/micropython/releases/download/v1.28.0/micropython-1.28.0.tar.xz"
  sha256 "4e43c59657b8da33b4bc503509a827cc3ea6cb66c446475c57776cf4467ba215"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b9e246967c3fca0f66bf6c65d9937f76fc14a738d04e233c98eb810a8b3ea60a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e04aeea3bbcf80513ca0d2741c48048e29ebebe864dc0086fa6789f6215eee2e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "82c1047381990879ebd8f9a69e7bcb084bc6ae305630a94dae765e4869cd48db"
    sha256 cellar: :any_skip_relocation, sequoia:       "5c0f58c5e679575f31601cc74a39eb282b7c46c4372106f0ae02860ec2b829a4"
    sha256 cellar: :any_skip_relocation, sonoma:        "4deb6dbd68198e3539a1de7b7ae3f66b8ed5c92582d6c08c0bbecc2057c087b1"
    sha256 cellar: :any,                 arm64_linux:   "68b57d700836bfcd7d6f490a68dc7a232c3ac96700f326fbb827a7fca6d4e4e3"
    sha256 cellar: :any,                 x86_64_linux:  "0e529deb327b8e56e20f9d92317de3f08ee7d65609b66342189a77e3b922afea"
  end

  depends_on "pkgconf" => :build
  uses_from_macos "libffi"
  uses_from_macos "python" # Requires libffi v3 closure API

  def install
    system "make", "-C", "ports/unix", "install", "PREFIX=#{prefix}"
    bin.install "mpy-cross/build/mpy-cross"
  end

  test do
    lib_version = "6" if OS.linux?

    # Test the FFI module
    (testpath/"ffi-hello.py").write <<~PYTHON
      import ffi

      libc = ffi.open("#{shared_library("libc", lib_version)}")
      printf = libc.func("v", "printf", "s")
      printf("Hello!\\n")
    PYTHON

    system bin/"mpy-cross", "ffi-hello.py"
    system bin/"micropython", "ffi-hello.py"
  end
end
