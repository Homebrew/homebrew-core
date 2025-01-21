class Micropython < Formula
  desc "Python implementation for microcontrollers and constrained systems"
  homepage "https://www.micropython.org/"
  url "https://github.com/micropython/micropython/releases/download/v1.24.1/micropython-1.24.1.tar.xz"
  sha256 "5d624a0b23389134d963b204601db9bc4ca57bfb615d13f13592bc2b5b494c03"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7119417af2aac51f933f3fdf56463271e059a5809a3fed2156d1f581fdedf70c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "90640d85ddaee22d1e8c811d4a0a77684cd61959634428e673a8e70958a18803"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "8ca6087dc2087c3bdd0c83be91573ef2c5ea24fab910b7d80d934f23deb5ec1b"
    sha256 cellar: :any_skip_relocation, sonoma:        "dfe7cd0c32d85d09ab9ae8c747c4fa0201e987cf00f16ea27c47756bd98613f1"
    sha256 cellar: :any_skip_relocation, ventura:       "6601736a89957321cdb26111f3d6da67575ee7a5324b1af791cf2370240b259b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "051ed9e99ab5253da80a44cae0e8bcc177f0da957b1f67261f10801798b39e9f"
  end

  depends_on "pkgconf" => :build
  uses_from_macos "libffi", since: :catalina
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
