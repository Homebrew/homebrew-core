class Decker < Formula
  desc "HyperCard-like multimedia sketchpad"
  homepage "https://beyondloom.com/decker/"
  url "https://github.com/JohnEarnest/Decker/archive/refs/tags/v1.64.tar.gz"
  sha256 "fafcc0cd250b80f5ddc8df106eb0a0e8d3efa2827fc9e107b6385de9f37a06c4"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "10bf178dd103e6b7fa9a28f7cc8dc4538afe4a2830eb32687f554eb64d5439e8"
    sha256 cellar: :any,                 arm64_sequoia: "c0c64fe7c80b427aaf1ca5b3b26735b251f35031c9da84860636b1e9ecb40efb"
    sha256 cellar: :any,                 arm64_sonoma:  "f9285703b38641e8fa9e7cdb30984519eb28639c0c857bb8b066a61f69828d4d"
    sha256 cellar: :any,                 sonoma:        "86a1cff7d60796d1c8a342dbb8c3934d7316e3647e6f2cccb08ae34f42c13685"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e15653174d3f5a5f05894982842ff55064e234fab4993d31b2ef5adc38c60fa1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3db28acd37c349d4e7d1f8083e95bee6b4e37d93f47f9864186b9b2aaa11af34"
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
