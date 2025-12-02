class Decker < Formula
  desc "HyperCard-like multimedia sketchpad"
  homepage "https://beyondloom.com/decker/"
  url "https://github.com/JohnEarnest/Decker/archive/refs/tags/v1.63.tar.gz"
  sha256 "b27fa1eac53b3355551b75bc83e012b6240493a7a47ce5e113600d210c76d5f6"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "5ea3ffbc994cb37a8a3f95249be3ca1f3ed0fc82885aae5f5a271f5a5af6f516"
    sha256 cellar: :any,                 arm64_sequoia: "1dffce917d194a3f3281da4f7af7bdbe95317bd89aaab5e7fec254faf384df62"
    sha256 cellar: :any,                 arm64_sonoma:  "76994a5622efe7980fcb8f25f225ce4af52f7beb9b8e876e98f5a70037ddb651"
    sha256 cellar: :any,                 sonoma:        "ddb56a5a1511b85bab02ddf32cd1e201974e867b93ee853f1326382098e183b8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "89fe755bd85dafad8cc1d0c54aa452abb5e6b5f688e5c99b006586b622094d9f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9bac03867fc5da82a0921c8b9c0c81081defe5de8f70da8bf4e2c1a85e774306"
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
