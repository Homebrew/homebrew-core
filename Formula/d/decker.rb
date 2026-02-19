class Decker < Formula
  desc "HyperCard-like multimedia sketchpad"
  homepage "https://beyondloom.com/decker/"
  url "https://github.com/JohnEarnest/Decker/archive/refs/tags/v1.63.tar.gz"
  sha256 "922f6989549e3556122f9e90130944d728b4ad581837d3f3ca97120e1adae651"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "058b9392b725361d0386ab86025c0754cc5e452107bb468b5b08f7e52fb9c1b7"
    sha256 cellar: :any,                 arm64_sequoia: "10e4b15cd821d49470cbbb4408ed70f4c2606b1f7fcdf4c18a30286996d42262"
    sha256 cellar: :any,                 arm64_sonoma:  "c7209756445979e6c9c7d7293f112e7d74d92030acf768e09b483c1472b54a52"
    sha256 cellar: :any,                 sonoma:        "419209ee02104ef8f04d77de895c1db2cc9af72267a2879034f1cd1d612fc067"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "36aaa0d904df03c10a89db14640b36827e3555b29777cf584f2cd92fad65d434"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d4bf2c16782282e6a6efb4c1a989923b45fb803b1b1ea51a3f0a7f423386f56a"
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
