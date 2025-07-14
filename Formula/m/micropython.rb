class Micropython < Formula
  desc "Python implementation for microcontrollers and constrained systems"
  homepage "https://www.micropython.org/"
  url "https://github.com/micropython/micropython/releases/download/v1.25.0/micropython-1.25.0.tar.xz"
  sha256 "9fe99ad5808e66bb40d374f5cad187c32c7d1c49cf47f72b38fd453c28c2aebe"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "470bfae6fc4f82301df5ae1f265b00d7b981a5db70120b4242b67890c5190a98"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "545f7cf7279b407e843e349024e2fcd264032be5312c1bd7fc9a59f440aae5fb"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "295730364d3c8f548e2fa71c71d9ddbb5acd3dd7b1e37ee3cc2af7862f4f92c3"
    sha256 cellar: :any_skip_relocation, sonoma:        "936cc289f796f38be76d8e61d895498007aac8a3d686d3a7f10260d77cb77657"
    sha256 cellar: :any_skip_relocation, ventura:       "2d473ef1dbda05c2759730d8c592599ce8a5712ea2607154db81c0244258241e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7a9e34b94bc6d146b7c7db61c02fba86eedf56812dc389fbe0b8d712d54c43a2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3e6f131cc475b96a98e22d54c82905c055d46072a4b15d6fdb027fe25100d25d"
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
