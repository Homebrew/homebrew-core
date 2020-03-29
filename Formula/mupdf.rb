class Mupdf < Formula
  desc "Lightweight PDF and XPS viewer"
  homepage "https://mupdf.com/"
  url "https://mupdf.com/downloads/archive/mupdf-1.16.1-source.tar.xz"
  sha256 "6fe78184bd5208f9595e4d7f92bc8df50af30fbe8e2c1298b581c84945f2f5da"
  head "https://git.ghostscript.com/mupdf.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "5ed11ba3dedbb091f7527e29616ffc74f41e204b67adef559b1feea8e9a04f29" => :catalina
    sha256 "166af075df8ac8374106cb5d5bc21ef02038c16b1d36bb13144f1361f7a77a0a" => :mojave
    sha256 "fc9ac2f447ab5df1a42110f252c4f665d1be41fd820556e63e26fb19d41f3ca5" => :high_sierra
  end

  depends_on :x11

  conflicts_with "mupdf-tools",
    :because => "mupdf and mupdf-tools install the same binaries."

  def install
    system "make", "install",
           "build=release",
           "verbose=yes",
           "CC=#{ENV.cc}",
           "prefix=#{prefix}"

    # Symlink `mutool` as `mudraw` (a popular shortcut for `mutool draw`).
    bin.install_symlink bin/"mutool" => "mudraw"
    man1.install_symlink man1/"mutool.1" => "mudraw.1"
  end

  test do
    assert_match "Homebrew test", shell_output("#{bin}/mudraw -F txt #{test_fixtures("test.pdf")}")
  end
end
