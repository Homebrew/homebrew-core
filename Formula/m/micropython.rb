class Micropython < Formula
  desc "Python implementation for microcontrollers and constrained systems"
  homepage "https://www.micropython.org/"
  url "https://github.com/micropython/micropython/releases/download/v1.23.0/micropython-1.23.0.tar.xz"
  sha256 "0ab283c2fc98d466c1ff26692bee46abaeeab55d488a36fc3cb6372cb8fb390d"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "1c369cfa8cc0ff68f03cc20bcaed1dceaf707516887fe119d3a6d066f673ae1d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f033be5a444507e39018097ca119d79c5f558e7131f4edf9aa779c7f2c927aed"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0008a2980b28e2d667e0c117af60d98a0cce95143682e77409148c1b05a3f120"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "926a24badb2f366052f71c65ac5e137ee7073b379585290aff5f704f974a2312"
    sha256 cellar: :any_skip_relocation, sonoma:         "4e302bf2b99a2686d2fa5a0ce3847b7ea7bff83952c19b719c65dff582469f99"
    sha256 cellar: :any_skip_relocation, ventura:        "b27a137fc0838dc99f989bb76d133bc0796457b1f94df3f153ac93971df35b44"
    sha256 cellar: :any_skip_relocation, monterey:       "798cf0293bc2177715e7712b702b7dafab132ebc09602ea133404c9422bc4b0c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8b5eee660350ffe515a12a0f440cc311226227da4b69071ba3be38fb09eed9fb"
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
