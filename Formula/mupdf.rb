class Mupdf < Formula
  desc "Lightweight PDF and XPS viewer"
  homepage "https://mupdf.com"
  url "https://mupdf.com/downloads/mupdf-1.11-source.tar.gz"
  sha256 "209474a80c56a035ce3f4958a63373a96fad75c927c7b1acdc553fc85855f00a"

  bottle do
    cellar :any_skip_relocation
    sha256 "c6ba5009c3d93bef7271abf1237966ef37668ca7c4efa9acbb08c2b34ecc13b7" => :sierra
    sha256 "c1730640c3797ffad7c67637a640ca97d882ff71f7a625bcf0b6bdea38f04374" => :el_capitan
    sha256 "37886d6e77a7842c2c05e29bcc8d4035f555ca7a2538121399d607a52d5d2cc2" => :yosemite
  end

  depends_on :macos => :snow_leopard
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
