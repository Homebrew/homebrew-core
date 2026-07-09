class Decker < Formula
  desc "HyperCard-like multimedia sketchpad"
  homepage "https://beyondloom.com/decker/"
  url "https://github.com/JohnEarnest/Decker/archive/refs/tags/v1.68.tar.gz"
  sha256 "29d52a275b0b55bc466ef285ddcfaf58dce78a1810d196fa05b08c710ee5c817"
  license "MIT"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "3d175e9e4331c30ef9e975a3b999746232bc9db6617ad1b82acc815a95df614b"
    sha256 cellar: :any, arm64_sequoia: "a3b378115b6052fb9dc2a7ed262410349791216e92d6dd0841f0bcc6a8e9c73f"
    sha256 cellar: :any, arm64_sonoma:  "88b6751fb8df2784bc20a69bbf92c068fd0d2a12ee807ba6bd94c91ee632790c"
    sha256 cellar: :any, sonoma:        "20053fa94a6ba78534947a4435386f86136e9f531717583e8276ce38a0413da3"
    sha256 cellar: :any, arm64_linux:   "cadbff5edff5b7ae9222cce903c1e6330a6c920c8c079886adc76c0ce3ef1e8f"
    sha256 cellar: :any, x86_64_linux:  "936969bcba03d2992920f682ceb0312702cd097969ef8bab7e884eeec5d73d78"
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
