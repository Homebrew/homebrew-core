class Mupdf < Formula
  desc "Lightweight PDF and XPS viewer"
  homepage "https://mupdf.com/"
  url "https://mupdf.com/downloads/mupdf-1.13.0-source.tar.gz"
  sha256 "071c6962cbee1136188da62136596a9d704b81e35fe617cd34874bbb0ae7ca09"
  head "https://git.ghostscript.com/mupdf.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "533293ae8a45533a1dd70a90f736c2aa1d7858782f19248a704a30c4ddc060dc" => :high_sierra
    sha256 "30591da2955a812f833e94e852a7292a95e5e59365faa3e143aeeb7927a8cd2a" => :sierra
    sha256 "96b2f59e4f35d2efb229df4a1b7e4d8c02f4dcdb0ee4f3d95f8352d5b1cacfe8" => :el_capitan
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
