class Decker < Formula
  desc "HyperCard-like multimedia sketchpad"
  homepage "https://beyondloom.com/decker/"
  url "https://github.com/JohnEarnest/Decker/archive/refs/tags/v1.70.tar.gz"
  sha256 "c06e04f677cc3e799056d4b6250c0947eb463dae1f703e491236d572f6eb6162"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "3a170025d4568179f0dec19cc4a96dabbc12f46daa6a96ee372d28b99809ee48"
    sha256 cellar: :any, arm64_sequoia: "7bfc08b6a90ff824cfb2fca4021bb5fda18ac806c94fb1c1bdd6b18ca9e8e431"
    sha256 cellar: :any, arm64_sonoma:  "434bc7a14a0c37ea2553c519b97db6ff8fb748096b1665de9b7014402dd666fa"
    sha256 cellar: :any, sonoma:        "af54884554340a8513842f8f719f03264273366004fda6b6288d23e8ddee4008"
    sha256 cellar: :any, arm64_linux:   "f307fe797d17fdb2d6406115d6a540d3f442f9e4e4cec92765bc3709c559ffb7"
    sha256 cellar: :any, x86_64_linux:  "c1de056afb3c4d3d7b5f16d6d535ba75bd9dd03043b8e87e97ee004b0d82411f"
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
