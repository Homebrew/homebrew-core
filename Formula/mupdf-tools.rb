class MupdfTools < Formula
  desc "Lightweight PDF and XPS viewer"
  homepage "https://mupdf.com/"
  url "https://mupdf.com/downloads/mupdf-1.13.0-source.tar.gz"
  sha256 "071c6962cbee1136188da62136596a9d704b81e35fe617cd34874bbb0ae7ca09"
  head "https://git.ghostscript.com/mupdf.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "aaeb5b84d303ddac285b08e1508d1ec7c51327e9dd51c878d45002cff348c1ba" => :high_sierra
    sha256 "e2784582c73bea831d1a23fef44e0b792fa073fe4ec9d0494b0f72a894e3cdd1" => :sierra
    sha256 "e4d44153713cd6029d9ab609d745a7a3c7984e532ababf5311280c319ab4ca99" => :el_capitan
  end

  # Reverts an upstream commit which is incompatible with the macOS GLUT;
  # the commit in question adds the use of a freeglut-only function and constants.
  # An earlier commit added explicit OS X GLUT support, so this looks like a bug.
  # https://bugs.ghostscript.com/show_bug.cgi?id=699374
  patch do
    url "https://gist.githubusercontent.com/mistydemeo/af049b9151363cd5d5fb58b8ce9e26b6/raw/1c4448c7c0e7c165c5805fd37b4de03ffb7f26fd/0001-Revert-gl-Tell-glut-to-return-from-main-loop-when-th.patch"
    sha256 "e5c5d00874f09c6f70a1fd8db7e86f0d386c88bc209dcb287f4eef644c1de44b"
  end

  def install
    system "make", "install",
           "build=release",
           "verbose=yes",
           "HAVE_X11=no",
           "CC=#{ENV.cc}",
           "prefix=#{prefix}"

    # Symlink `mutool` as `mudraw` (a popular shortcut for `mutool draw`).
    bin.install_symlink bin/"mutool" => "mudraw"
    man1.install_symlink man1/"mutool.1" => "mudraw.1"
  end

  test do
    assert_match "Homebrew test", shell_output("#{bin}/mutool draw -F txt #{test_fixtures("test.pdf")}")
  end
end
