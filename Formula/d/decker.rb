class Decker < Formula
  desc "HyperCard-like multimedia sketchpad"
  homepage "https://beyondloom.com/decker/"
  url "https://github.com/JohnEarnest/Decker/archive/refs/tags/v1.72.tar.gz"
  sha256 "77e937d684943d605a0c3b209ed0ac323e22056233d8f9523bd4cad098994877"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "07213d6db1c5b1cc4007f23cb5806fc8b61f9941803705b19b0aca767388e85c"
    sha256 cellar: :any, arm64_tahoe:       "e576c5f4dd8c31744b52538f7564833981cca7f0e6144eb63c0f0bbbf8e5e418"
    sha256 cellar: :any, arm64_sequoia:     "b5cf6afb7c5ac5b35b87c8cbcc75f5fa4d3a646d08d6b5588f496f046a1e3915"
    sha256 cellar: :any, arm64_linux:       "422846d8ef9846e65b1224fe12fecae8e049d49de094273fce49278bdf271782"
    sha256 cellar: :any, x86_64_linux:      "25bcd653eb91dcff652c0ad8f28f3aaad667440c9d214d55b95427f39966e24e"
  end

  depends_on "sdl2-compat"
  depends_on "sdl2_image"

  on_linux do
    depends_on "vim" => :build # uses xxd
  end

  def install
    extra_flags = "-I#{HOMEBREW_PREFIX}/include/SDL2"
    system "make", "EXTRA_FLAGS=#{extra_flags}", "lilt"
    system "make", "EXTRA_FLAGS=#{extra_flags}", "decker"
    system "make", "PREFIX=#{prefix}", "install"
    pkgshare.install "examples"
  end

  test do
    assert_match '"depth":', shell_output("#{bin}/lilt #{pkgshare}/examples/lilt/mandel.lil")
  end
end
