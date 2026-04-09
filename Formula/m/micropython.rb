class Micropython < Formula
  desc "Python implementation for microcontrollers and constrained systems"
  homepage "https://www.micropython.org/"
  url "https://github.com/micropython/micropython/releases/download/v1.27.0/micropython-1.27.0.tar.xz"
  sha256 "9874b20646c3bbe81d524f779a16875e5d088b7065e175ffd2aa2a02f50573c9"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5392dcf56b201508f151c1a149296b693aa9f91fb48478365c967cf5351fc257"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e27ce56e280a609a42f302ffa2ece5ba1dde88e70b3713c02096cca7f0c0e8d2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "484b01b9e68a5ae8d6826ef89494d3a7d96065b74349a0eb334584dfc106efa1"
    sha256 cellar: :any_skip_relocation, tahoe:         "df392e2818faded81b4596d98073a2ace572493f081337b0c861021124b3f4b4"
    sha256 cellar: :any_skip_relocation, sequoia:       "018c5e63b1d8c8b180fd9e7f512e0e372715a2314deea95daa38ddedcaae1c87"
    sha256 cellar: :any_skip_relocation, sonoma:        "e7fd12774208d0d5578bb9b2bf69b271b54edf3aaf6f5332134555d1209dd7a0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "501a9d4456b62405f9be50f9774e3213afc0b17d2164eaade991ea0c7329585b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5be6aa91a71cb44c4e7a312e81452450428587cb04b4f0051ff163c5a6731758"
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
