class Decker < Formula
  desc "HyperCard-like multimedia sketchpad"
  homepage "https://beyondloom.com/decker/"
  url "https://github.com/JohnEarnest/Decker/archive/refs/tags/v1.65.tar.gz"
  sha256 "751bfa045fef69132feae82bbbac5d31cc362d6c775f9e43bca300a46c0f5b73"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "4b22a53f256d2bebe1212d8e5b08626b357a379b447b50bd276068c8cfede184"
    sha256 cellar: :any,                 arm64_sequoia: "f3df899cf961219f0f931b70fcda0f86b91cce5580a6ca54596e4b1f2b4cc122"
    sha256 cellar: :any,                 arm64_sonoma:  "55d1a52b6031dd4418c9d90fe756f2af7c81cd91c6d66a5302438fb55a5205bb"
    sha256 cellar: :any,                 sonoma:        "8108a8b884fae1848bf289f158fd5cc7cdee35d9a36a93af3935f8a6fc12128a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f2e477d77e815f1b753f5e8763fe7b3c15cea6718696eec6b066f1cd445c68fa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1b55ff7380eb1734f103fd9fa17e3fdcf399e2d6ab37f1c8b331889f37c32b64"
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
