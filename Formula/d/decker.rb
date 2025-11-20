class Decker < Formula
  desc "HyperCard-like multimedia sketchpad"
  homepage "https://beyondloom.com/decker/"
  url "https://github.com/JohnEarnest/Decker/archive/refs/tags/v1.61.tar.gz"
  sha256 "85c4eb42a1a986f997438317a7cca54a4b27bff9a621c2b6e7c55e1288439287"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "7503099783f8f0781fb71b5be796350843033b463223d0b322906de687bf695b"
    sha256 cellar: :any,                 arm64_sequoia: "a64853dd827468960f00053b372fe768864e6e867bf5ad24cee5a19b0deb4f4a"
    sha256 cellar: :any,                 arm64_sonoma:  "c6d1d0e6e2f24ec97f491b48cc5eb7273d79979403e7a98d44b44f2945da986a"
    sha256 cellar: :any,                 sonoma:        "c04fda8355b3568ce8593ab6c5b2298971839c99a598d1d0611c92c29a3ce9e6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "26887fce224dc9970c4d3492efed104214424db627648129305962f5befbb365"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "46f6bf8755974f86abb89e964470b0abbdc47e9b9f0520b210b256449004f451"
  end

  depends_on "sdl2"
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
