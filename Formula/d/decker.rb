class Decker < Formula
  desc "HyperCard-like multimedia sketchpad"
  homepage "https://beyondloom.com/decker/"
  url "https://github.com/JohnEarnest/Decker/archive/refs/tags/v1.59.tar.gz"
  sha256 "dfa3008810eb64d767adb2cdb73ccf1a1e54480e749ac2f82ab9de21c4a32320"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "69f62142cfa66aa202be5c93fc256a2bd2df674be17b27b38f297b1bb4bd8a06"
    sha256 cellar: :any,                 arm64_sequoia: "10ebece6b16fe1c20a9473d9b4a746b5f37cfe91158dda2d8681dd4bf27eedcf"
    sha256 cellar: :any,                 arm64_sonoma:  "5acbe7e8e31b9beede0f735d94b3b320e3993b69db0a4317aeda9af4f168802b"
    sha256 cellar: :any,                 sonoma:        "2ccf365f9df42abddca3f2d2b9d2868cd6c68e8974989a63eaecd7538b5b62bf"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7c7eeade8495c901fc81bff37e2547a827d5eb70823a2147e52849d4c80f82ec"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d9395ce3cc62d05c8cf277a1200cd536dce96ef6ded1803aaa3c282c59db4202"
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
