class Advancecomp < Formula
  desc "Recompression utilities for .PNG, .MNG, .ZIP, and .GZ files"
  homepage "https://www.advancemame.it/comp-readme.html"
  url "https://github.com/amadvance/advancecomp/releases/download/v2.1/advancecomp-2.1.tar.gz"
  sha256 "3ac0875e86a8517011976f04107186d5c60d434954078bc502ee731480933eb8"
  revision 1

  bottle do
    cellar :any_skip_relocation
    sha256 "fccdb14eb1a620c824c08e748db390d788ad797c30654cb6434205fb16c78784" => :catalina
    sha256 "798de4490c97283280259ffc1dc39159bd0ded85edb47f3212ad5ec9a174289e" => :mojave
    sha256 "fdb2a72157445c33a462388f05580489c427f4f0d2a3d4cdc1b7867ef69e7e53" => :high_sierra
    sha256 "4ef3590e26c5ac96d64dc985b035ec7055f215c84d31dfb09542d958f6ec4e77" => :sierra
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  uses_from_macos "bzip2"
  uses_from_macos "zlib"

  def install
    system "autoreconf", "-fiv"
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--enable-bzip2", "--prefix=#{prefix}", "--mandir=#{man}"
    system "make", "install"
  end

  test do
    system bin/"advdef", "--version"

    cp test_fixtures("test.png"), "test.png"
    system bin/"advpng", "--recompress", "--shrink-fast", "test.png"

    version_string = shell_output("#{bin}/advpng --version")
    assert_includes version_string, "advancecomp v#{version}"
  end
end
