class Fwup < Formula
  desc "Configurable embedded Linux firmware update creator and runner"
  homepage "https://github.com/fhunleth/fwup"
  url "https://github.com/fhunleth/fwup/releases/download/v1.2.4/fwup-1.2.4.tar.gz"
  sha256 "25a0cc2576f610acb7c73d113a885f328ca328afba435a6cced97236236ceadc"

  bottle do
    cellar :any
    sha256 "750b1f8180e5726fad73544e9309eb195cc9ab565fa843dcdf65c970bdced8bb" => :high_sierra
    sha256 "0ca2df854c05ef868cce012939ac5c8541536fdad0e321761fe7a703c0633213" => :sierra
    sha256 "35ab128fd539946dbdd94abebd5079ba8c1826c70400f921059dcb8b089e4a31" => :el_capitan
  end

  depends_on "pkg-config" => :build
  depends_on "confuse"
  depends_on "libarchive"
  depends_on "libsodium"

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-dependency-tracking"
    system "make", "install"
  end

  test do
    system bin/"fwup", "-g"
    assert_predicate testpath/"fwup-key.priv", :exist?, "Failed to create fwup-key.priv!"
    assert_predicate testpath/"fwup-key.pub", :exist?, "Failed to create fwup-key.pub!"
  end
end
