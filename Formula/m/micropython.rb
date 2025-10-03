class Micropython < Formula
  desc "Python implementation for microcontrollers and constrained systems"
  homepage "https://www.micropython.org/"
  url "https://github.com/micropython/micropython/releases/download/v1.26.1/micropython-1.26.1.tar.xz"
  sha256 "12be6514df6272c0fcb328122b534af6b12abdd52435c19f40ee1707cc43ac98"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "34d4153eff140960050eb3b08c24cbfe138fbd55e85c8118a56d4d9e2012d555"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0ab765f5f1bc6fa2898c55f91bc30a0d0f1c8581296c0d0453e259be597bae1d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f2ecdd66d12c3eb0c78b8d1d85c09c50253f5b5cc5075caaf7ddaa852ab898b9"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "122acd6b2da763a9f73f0407c00cf83edba31a4bcf6def7a56836d6d8e57da0e"
    sha256 cellar: :any_skip_relocation, tahoe:         "92ac93ba0e90802dcd12bfd9f7584baabb2b8cf7ed8165615e4aacf488463693"
    sha256 cellar: :any_skip_relocation, sequoia:       "80401bccc9ea2bda8139bda5e3866ff866b1109e9bd33b7a6224140ee4f9d1a0"
    sha256 cellar: :any_skip_relocation, sonoma:        "6391ea2db27df106305c64d2d9f0ceef198532b5fd377bbe4f38635cd65b17ea"
    sha256 cellar: :any_skip_relocation, ventura:       "1eaf682cf59c352b82b4fa32a7f312c32a9e2bf60a696a435bb525eced8aedf1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9acbde114ad7800db94b5552fa90d6368047baaa50b64e42aaabdd5a8d19c073"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1acb20eb6021d0874771f73ea6e071e25c06983b56f2c2725ecedf15961c6b9c"
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
