class Decker < Formula
  desc "HyperCard-like multimedia sketchpad"
  homepage "https://beyondloom.com/decker/"
  url "https://github.com/JohnEarnest/Decker/archive/refs/tags/v1.56.tar.gz"
  sha256 "395cf6968d23b9a36323597713743aac93b3e0aa8251359c403b747cfee893bd"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "b932441e09632a338e4b6e636a8aafbd4a3aeba6f413a8743cb850dfd9bce077"
    sha256 cellar: :any,                 arm64_sonoma:  "8af7a26ac4154985ab72827de55e6cef9014f2b99e7439267f017790a5c5d249"
    sha256 cellar: :any,                 arm64_ventura: "78bebccdfbb44a85d0bd0bbfd4f27645464ca33cafa944fcce15610c258dc71b"
    sha256 cellar: :any,                 sonoma:        "210cb074001ff2128e36ff58e083db477a0bfbf9935c8410448f40dff7a77e6e"
    sha256 cellar: :any,                 ventura:       "a94c0dd0f340892b5e6a18745983065196f9c103017095c9f8f5c2a18f764b14"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "47e6ea41cbdeccb22bb40b323eb48350913702e9f078d85b14940832ad6ddc44"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "492440a007d4c501ea67c46ec3c8be713a6b26ec794ee300101e86d8fccc55d6"
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
