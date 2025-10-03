class Decker < Formula
  desc "HyperCard-like multimedia sketchpad"
  homepage "https://beyondloom.com/decker/"
  url "https://github.com/JohnEarnest/Decker/archive/refs/tags/v1.60.tar.gz"
  sha256 "7ead137f20588711c50e04a432c84f1ac1ca7fa71f3e7bf547b315ce34891a9a"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "39400735705c94667f90a70c48b4b194f350ae38c30f04a07fff4921e0ab3de6"
    sha256 cellar: :any,                 arm64_sequoia: "36f133feb00168761d7846d90c6c705bfc3afe3ce940fe57a1859b35c1bb824d"
    sha256 cellar: :any,                 arm64_sonoma:  "6f0240e034e4156247dff2b47ddada4970161997914c3d72860520c4b434c3a3"
    sha256 cellar: :any,                 sonoma:        "6c44cd3c87d02fde0406653c72bbb97173c167bbc5c1df36529319f017494c79"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e7210b26ed5b205182d5a9d806c740703fa312f4b402a38640944e931face441"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7c7dfa7957186df10d33c95aaedc70092c45a61c3b6ee570a97ee86061498564"
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
