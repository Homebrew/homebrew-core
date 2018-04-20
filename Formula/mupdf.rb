class Mupdf < Formula
  desc "Lightweight PDF and XPS viewer"
  homepage "https://mupdf.com/"
  url "https://mupdf.com/downloads/mupdf-1.13.0-source.tar.gz"
  sha256 "071c6962cbee1136188da62136596a9d704b81e35fe617cd34874bbb0ae7ca09"
  head "https://git.ghostscript.com/mupdf.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "4b9122fa576b3bb24754016fa9dad09113dcbe0fe982cff3341d0f8d718fae25" => :high_sierra
    sha256 "a9745c00b9efe835197f89e973f4b25698567c011aa1fdf3052c586ba3503a87" => :sierra
    sha256 "771078a7ae9a600933d1f38ff80389b7bc158e8aecde9c9c7bf7aecddc75e7a8" => :el_capitan
  end

  depends_on :x11
  depends_on "openssl"

  conflicts_with "mupdf-tools",
    :because => "mupdf and mupdf-tools install the same binaries."

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
           "CC=#{ENV.cc}",
           "prefix=#{prefix}"
    bin.install_symlink "mutool" => "mudraw"
  end

  test do
    assert_match "Homebrew test", shell_output("#{bin}/mudraw -F txt #{test_fixtures("test.pdf")}")
  end
end
