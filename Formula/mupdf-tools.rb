class MupdfTools < Formula
  desc "Lightweight PDF and XPS viewer"
  homepage "https://mupdf.com/"
  url "https://mupdf.com/downloads/archive/mupdf-1.15.0-source.tar.xz"
  sha256 "565036cf7f140139c3033f0934b72e1885ac7e881994b7919e15d7bee3f8ac4e"
  head "https://git.ghostscript.com/mupdf.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "2777f9f600980f2dc9a08607f6b8cd63e0d34a76579a2c96a5cddc6b9abc919d" => :catalina
    sha256 "bca11e9d9e1e2fefbf2aecfdabe5152aa9d2ac0a026690fa9f63fdc7a480f002" => :mojave
    sha256 "34787901ceaf810b88d553a40f2307a4255056ada19323f8d742e87727bfb33d" => :high_sierra
  end

  def install
    # Work around Xcode 11 clang bug
    ENV.append_to_cflags "-fno-stack-check" if DevelopmentTools.clang_build_version >= 1010

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
