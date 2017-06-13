class Mupdf < Formula
  desc "Lightweight PDF and XPS viewer"
  homepage "https://mupdf.com/"
  url "https://mupdf.com/downloads/mupdf-1.11-source.tar.gz"
  sha256 "209474a80c56a035ce3f4958a63373a96fad75c927c7b1acdc553fc85855f00a"
  head "https://git.ghostscript.com/mupdf.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "db79eda74b6e0aee69a92859a72a9cbb9a4497ff7fbdb73bce2af1984b93b1a3" => :sierra
    sha256 "a05de229404807b12a302da6d85141701d6b31e528ae4dbb612ad53d65b73221" => :el_capitan
    sha256 "4a6fda775162b101b4fe907bda57277fcb19514aaa4ae434ef6ad155ee72e649" => :yosemite
  end

  depends_on :x11
  depends_on "openssl"

  conflicts_with "mupdf-tools",
    :because => "mupdf and mupdf-tools install the same binaries."

  def install
    # Work around bug: https://bugs.ghostscript.com/show_bug.cgi?id=697842
    inreplace "Makerules", "RANLIB_CMD := xcrun", "RANLIB_CMD = xcrun"

    system "make", "install",
           "build=release",
           "verbose=yes",
           "CC=#{ENV.cc}",
           "prefix=#{prefix}",
           "HAVE_GLFW=no" # Do not build OpenGL viewer: https://bugs.ghostscript.com/show_bug.cgi?id=697842
    bin.install_symlink "mutool" => "mudraw"
  end

  test do
    assert_match "Homebrew test", shell_output("#{bin}/mudraw -F txt #{test_fixtures("test.pdf")}")
  end
end
