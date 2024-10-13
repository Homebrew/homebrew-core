class Dav1d < Formula
  desc "AV1 decoder targeted to be small and fast"
  homepage "https://code.videolan.org/videolan/dav1d"
  url "https://code.videolan.org/videolan/dav1d/-/archive/1.4.3/dav1d-1.4.3.tar.bz2"
  sha256 "2a7e68a17b22d1c060d31a7af84c8e033a145fca1d63ef36d57f0f39eb4dd0df"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia:  "20533b85dad985944d973153954730fc07b04eeb23ca9355fe8056aa67b7afee"
    sha256 cellar: :any,                 arm64_sonoma:   "a8796b7771dbdd9d51ab510995dbe75aa9ba48b055b916259751d6b29e237898"
    sha256 cellar: :any,                 arm64_ventura:  "b1bdbc8f2eb6f66512d68aadb16112931959d09aea536961aa4ea846c824220a"
    sha256 cellar: :any,                 arm64_monterey: "c516bd88350520aadc8f9a967b94b26250e142f98916028c2b55000e062a6501"
    sha256 cellar: :any,                 sonoma:         "b80dee5a17dd4454c8962747395f57dfa6aeeacf08b961be2ead22aa8cd4ba57"
    sha256 cellar: :any,                 ventura:        "715b45f3946beb07cf59b7ef70fc116fa70befcec8c201706c7b90f51a735573"
    sha256 cellar: :any,                 monterey:       "652dccbef6d8eb11e3f181cc21c72c7fa541b1b665d2e83dd6df634b1e7bfbb7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7bee2084f50577d41bdb8e36ae78c1b86538eff0ca5eb542c08d38c4d98a9295"
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
