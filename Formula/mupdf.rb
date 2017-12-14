class Mupdf < Formula
  desc "Lightweight PDF and XPS viewer"
  homepage "https://mupdf.com/"
  url "https://mupdf.com/downloads/mupdf-1.12.0-source.tar.gz"
  sha256 "5c6353a82f1512f4f5280cf69a3725d1adac9c8b22377ec2a447c4fc45528755"
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
