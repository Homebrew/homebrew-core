class Decker < Formula
  desc "HyperCard-like multimedia sketchpad"
  homepage "https://beyondloom.com/decker/"
  url "https://github.com/JohnEarnest/Decker/archive/refs/tags/v1.67.tar.gz"
  sha256 "b09a1ecff0e513e1abf52156be2bc4d692f0dbd636d8c706315df92b88fbe84c"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "c85d493a5148d3b688abc7680d6634bee3bd1cf324ad0aa04ec2fddd984100d0"
    sha256 cellar: :any, arm64_sequoia: "90fadd9d9872777842bb1d70f6c8391bc17a65bbd5f8fbc2301d494d6bfad055"
    sha256 cellar: :any, arm64_sonoma:  "b57f191405e13570697ddada0cf3bac1cb2ccdca34c34ec6bc985d725a613ea8"
    sha256 cellar: :any, sonoma:        "0cf3072aabe3c01af689242ed4e8bdca6fa4de3886a3289901bc712f47cda483"
    sha256 cellar: :any, arm64_linux:   "a3a704670f6f92a7eb5791cac339a6bb20083b4a03f343e356839d078d3d7138"
    sha256 cellar: :any, x86_64_linux:  "d8ba34286684e653294336f46e7e95d511ab6aa7815a4633a6678b26203b3a16"
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
