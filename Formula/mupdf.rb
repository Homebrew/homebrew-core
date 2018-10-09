class Mupdf < Formula
  desc "Lightweight PDF and XPS viewer"
  homepage "https://mupdf.com/"
  url "https://mupdf.com/downloads/archive/mupdf-1.14.0-source.tar.gz"
  sha256 "c443483a678c3fc258fa4adc124146225d0bb443c522619faadebf6b363d7724"
  head "https://git.ghostscript.com/mupdf.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "ff48af84431d902475fd863213c719a493e234cea7780715cc33e259658b23f4" => :mojave
    sha256 "3fc3d421c951188f9aa9900d68d0c02475bcebb404a8cc79d962f73ebc29be2f" => :high_sierra
    sha256 "5bbec2ae4979636e506a413759d5f81928fb299b9bf9fbecf902cc150d3d2142" => :sierra
  end

  depends_on "openssl"
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
