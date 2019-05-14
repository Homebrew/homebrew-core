class MupdfTools < Formula
  desc "Lightweight PDF and XPS viewer"
  homepage "https://mupdf.com/"
  url "https://mupdf.com/downloads/archive/mupdf-1.15.0-source.tar.xz"
  sha256 "565036cf7f140139c3033f0934b72e1885ac7e881994b7919e15d7bee3f8ac4e"
  head "https://git.ghostscript.com/mupdf.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "cdef022dd6020e97503ede16d8d0f78c33bcd0290420379c848792ca92eabbcc" => :mojave
    sha256 "8178f8da3a5d8f45678c5563cc005ea70a93439c2d68dc8daa7716ec6bb58715" => :high_sierra
    sha256 "9327d7061bffc2f1319e124a5fb5d09921d1855249c8aca18568f5830f0db485" => :sierra
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
