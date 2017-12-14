class MupdfTools < Formula
  desc "Lightweight PDF and XPS viewer"
  homepage "https://mupdf.com/"
  url "https://mupdf.com/downloads/mupdf-1.12.0-source.tar.gz"
  sha256 "5c6353a82f1512f4f5280cf69a3725d1adac9c8b22377ec2a447c4fc45528755"
  head "https://git.ghostscript.com/mupdf.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "7eb4803bf32d2a707e288f7b2dba4ca2c6901710319d57f711a0508410365290" => :high_sierra
    sha256 "3965df825d42f96d755f9e342dd3820d02a6efd0dd16d13f6a6aea61eb9e7b04" => :sierra
    sha256 "b5464cc77a6468ceabccb15817669857f447dd4dc332a8e7b3c2027db2b43f0d" => :el_capitan
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
