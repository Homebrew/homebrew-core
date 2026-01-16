class Decker < Formula
  desc "HyperCard-like multimedia sketchpad"
  homepage "https://beyondloom.com/decker/"
  url "https://github.com/JohnEarnest/Decker/archive/refs/tags/v1.62.tar.gz"
  sha256 "56ebca420c946fe0ac99b896e6bd4d07c0f08f4f97610897d323b5cfa1940f02"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "1400662f32d196181f59c5d8576f663c5aa47e354aa536f5004e972520db089d"
    sha256 cellar: :any,                 arm64_sequoia: "ecc163afdee6f99b23937507d58542d3dc16f0cc55e0428f079478ea42986dc4"
    sha256 cellar: :any,                 arm64_sonoma:  "fd081790a0237c86501e633a2302a903b5ff78cbbfb786349cce0c3989e76d42"
    sha256 cellar: :any,                 sonoma:        "3075696db27dd53c917d5c285568161ba383ee110bd9fa3c81c197bbf4881e17"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0eaa1867b2eec5e55be75b874552f13c3fd0ea74880d88575cea7d4d004dfb09"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6d255fd7bc35a2307db75742da5dcdc2ec3f50299a9873969a086c11d4463bb1"
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
