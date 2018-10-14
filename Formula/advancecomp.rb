class Advancecomp < Formula
  desc "Recompression utilities for .PNG, .MNG, .ZIP, and .GZ files"
  homepage "https://www.advancemame.it/comp-readme.html"
  url "https://github.com/amadvance/advancecomp/releases/download/v2.1/advancecomp-2.1.tar.gz"
  sha256 "3ac0875e86a8517011976f04107186d5c60d434954078bc502ee731480933eb8"
  revision 1

  bottle do
    cellar :any_skip_relocation
    sha256 "8ff93fd8bbac329ab3f0d9a2dc0434092ce448c46a0b5d9b61c211c8132712a3" => :mojave
    sha256 "4e02eb49cfa3587545852bb5412ec4bed7a5a23bf7348798aa508fb1fe3c3840" => :high_sierra
    sha256 "0142bd73b77ee344b76be047323dea7593a03ee08b7041f789d8e1a330c5f7ec" => :sierra
    sha256 "adf23429f3c808c367520a4225caee3b2c7a2a8c4dea5bc8b28c8654f7e5b989" => :el_capitan
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build

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
