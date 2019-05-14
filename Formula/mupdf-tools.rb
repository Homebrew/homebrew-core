class MupdfTools < Formula
  desc "Lightweight PDF and XPS viewer"
  homepage "https://mupdf.com/"
  url "https://mupdf.com/downloads/archive/mupdf-1.15.0-source.tar.xz"
  sha256 "565036cf7f140139c3033f0934b72e1885ac7e881994b7919e15d7bee3f8ac4e"
  head "https://git.ghostscript.com/mupdf.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "e20c2295c7c3c373054ba83e9a9fe69ffdb0ea8934ce7312fdf44505d9673606" => :mojave
    sha256 "28897896f22e72d44a71ebb5851bcd71a07c669440c1f7f63d0a07502a11c5b0" => :high_sierra
    sha256 "ffe9e5694d30e98060e688dcd0e8f91fc3b4eb6f42da2eb336f2d3aec13b0f81" => :sierra
  end

  def install
    system "make", "install",
           "build=release",
           "verbose=yes",
           "HAVE_X11=no",
           "HAVE_GLUT=no",
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
