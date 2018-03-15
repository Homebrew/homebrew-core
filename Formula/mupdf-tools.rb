class MupdfTools < Formula
  desc "Lightweight PDF and XPS viewer"
  homepage "https://mupdf.com/"
  url "https://mupdf.com/downloads/mupdf-1.12.0-source.tar.gz"
  sha256 "5c6353a82f1512f4f5280cf69a3725d1adac9c8b22377ec2a447c4fc45528755"
  head "https://git.ghostscript.com/mupdf.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "02061e5a4e373b4d8283a23728ecef4d6a04d4562fce187d3354fdec65a595f4" => :high_sierra
    sha256 "a9c8080aea6e6f055c601c6ad4ff7752ad650ecf226e276b88a21c0eb21b317f" => :sierra
    sha256 "9cff7b00e334fd3f90ed6aee94fa57f02904db7a76b0af9aa611f37aff174004" => :el_capitan
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
