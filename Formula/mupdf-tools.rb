class MupdfTools < Formula
  desc "Lightweight PDF and XPS viewer"
  homepage "http://mupdf.com"
  url "http://mupdf.com/downloads/archive/mupdf-1.9a-source.tar.gz"
  sha256 "8015c55f4e6dd892d3c50db4f395c1e46660a10b460e2ecd180a497f55bbc4cc"
  head "git://git.ghostscript.com/mupdf.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "31a46e996dc2afb9348f64f3303833ed1c43ef8c4556e9510b3915a58d7a6745" => :sierra
    sha256 "091b901203e9633c053fccdd02644043ff9ab3d7e5c2ec72547d1966cfe74204" => :el_capitan
    sha256 "d626c89c21af7f672342d08675e6694f819deae30af76a66e7a0301c093a87de" => :yosemite
    sha256 "0dfd41dbe9c11575ce9a84449997d5291f8dca58066ac2fe4817b69178d09a6b" => :mavericks
  end

  depends_on :macos => :snow_leopard

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
    pdf = test_fixtures("test.pdf")
    assert_match "Homebrew test", shell_output("#{bin}/mutool draw -F txt #{pdf}")
  end
end
