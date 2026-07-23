class Decker < Formula
  desc "HyperCard-like multimedia sketchpad"
  homepage "https://beyondloom.com/decker/"
  url "https://github.com/JohnEarnest/Decker/archive/refs/tags/v1.69.tar.gz"
  sha256 "6c0ceab3f00388478a142d2ba12186483eb6beac5d1aa266ca80f79da81d9b36"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "6c6d30c0d3349d289468af71e6fcdec13254e05fd552320eae6b68c9b8bde821"
    sha256 cellar: :any, arm64_sequoia: "68734a4a9596375373e20ba77aa1b60a7d2e9f8909a13bf7ae8965bcf002763e"
    sha256 cellar: :any, arm64_sonoma:  "29f2250b9db65ab61b80e5d327f0e3c412b4eaeef305002ebc2826d7476b72b1"
    sha256 cellar: :any, sonoma:        "3719717c52aa9f4a70ca4239251cab32f5a138d34a255ea1594e685c9ab793f9"
    sha256 cellar: :any, arm64_linux:   "5d15805d4291aaf9d2cecdb5df14d59016f5009274f6bdd0b4939ccf8c435d02"
    sha256 cellar: :any, x86_64_linux:  "80e2ea70bbda05f15f64ac7cb81605c2f1244539fe6d498c8f222f112f8d2031"
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
