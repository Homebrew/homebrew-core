class Decker < Formula
  desc "HyperCard-like multimedia sketchpad"
  homepage "https://beyondloom.com/decker/"
  url "https://github.com/JohnEarnest/Decker/archive/refs/tags/v1.66.tar.gz"
  sha256 "5cf079affd52a34f9295bdeea71d4f7bff0352490dbb58f22db23ffe4b7a3613"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "76600dc834af52d266f114ed3f294bf1af9545b85cb6d938b1333fed8e8b840c"
    sha256 cellar: :any,                 arm64_sequoia: "3c50078c39b07971f24d4e695899cb56188bc39b7b631f61c21c9da91d0d95de"
    sha256 cellar: :any,                 arm64_sonoma:  "bd132ce940734e7c71cc969eafa802c2b092b0ea42cf18b94f854173c2a9c67c"
    sha256 cellar: :any,                 sonoma:        "028082af7f7985c5da042587168d839e07b4a0f22a15490113ac0195f6c3f3f5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9785d4e6a20a1eb257236050c46b0d1b1ee97eb5fc4dc388666ccbf13521c817"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0fd94e810290e442eaedb9b849a5bf894bb07bd32760f797d2a1f8013e72c6b0"
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
