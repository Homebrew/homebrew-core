class Dav1d < Formula
  desc "AV1 decoder targeted to be small and fast"
  homepage "https://code.videolan.org/videolan/dav1d"
  url "https://code.videolan.org/videolan/dav1d/-/archive/1.3.0/dav1d-1.3.0.tar.bz2"
  sha256 "bde8db3d0583a4f3733bb5a4ac525556ffd03ab7dcd8a6e7c091bee28d9466b1"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "990a082678f9dd0715c26d7fe77a893fbf926e5905bc79bc94062724431bfaaf"
    sha256 cellar: :any,                 arm64_ventura:  "b7a6cab7a7db69d7360d6146b4c1ba184adcfad7ff945521249aadedc366f336"
    sha256 cellar: :any,                 arm64_monterey: "b4a5e50c860540560e57165fd5592f8e6194950ad02344138b449f31e33f3831"
    sha256 cellar: :any,                 sonoma:         "a7e2fcfb84c890a2f2578e03410c24bfbd974f66b38726d99c616d830852d683"
    sha256 cellar: :any,                 ventura:        "ae755ea1f994808875cb904c86d9df75835c70bc40ec8a0fb8c0185a8dd24530"
    sha256 cellar: :any,                 monterey:       "bf7e7a913aae728df3ea00dc2b72966d62a7e717c07c225fb4212a0038fc4530"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3b7602d93001b697dbfb9582882cd51fc93dfca6e9e494c8643740928cbac89f"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build

  on_intel do
    depends_on "nasm" => :build
  end

  def install
    system "meson", "setup", "build", *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  test do
    resource "homebrew-00000000.ivf" do
      url "https://code.videolan.org/videolan/dav1d-test-data/raw/1.1.0/8-bit/data/00000000.ivf"
      sha256 "52b4351f9bc8a876c8f3c9afc403d9e90f319c1882bfe44667d41c8c6f5486f3"
    end

    testpath.install resource("homebrew-00000000.ivf")
    system bin/"dav1d", "-i", testpath/"00000000.ivf", "-o", testpath/"00000000.md5"

    assert_predicate (testpath/"00000000.md5"), :exist?
    assert_match "0b31f7ae90dfa22cefe0f2a1ad97c620", (testpath/"00000000.md5").read
  end
end
