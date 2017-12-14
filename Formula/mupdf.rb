class Mupdf < Formula
  desc "Lightweight PDF and XPS viewer"
  homepage "https://mupdf.com/"
  url "https://mupdf.com/downloads/mupdf-1.12.0-source.tar.gz"
  sha256 "5c6353a82f1512f4f5280cf69a3725d1adac9c8b22377ec2a447c4fc45528755"
  head "https://git.ghostscript.com/mupdf.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "95215e55299cdce622a221b831f50f37134ec9f9f895dbab1385f13c0f60a0ec" => :high_sierra
    sha256 "3f3632a8ae41b292881ba7ae74e1d018ca0b2ea8ad16bb24db20254c354afbbd" => :sierra
    sha256 "92906a3586f1689886e51f4063d62af7b1724788a46c2cdc3e7f4ba077caded6" => :el_capitan
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
