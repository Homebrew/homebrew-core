class Advancecomp < Formula
  desc "Recompression utilities for .PNG, .MNG, .ZIP, and .GZ files"
  homepage "https://www.advancemame.it/comp-readme.html"
  url "https://github.com/amadvance/advancecomp/releases/download/v2.1/advancecomp-2.1.tar.gz"
  sha256 "3ac0875e86a8517011976f04107186d5c60d434954078bc502ee731480933eb8"
  license "GPL-3.0"
  revision 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "15d65e064ee44f6847db2bf123ba7902476d9a78ce411acb34da2c03be3d1ed0"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4316c90600aecfa083b3ed1047a433fb649e14cb67d5eca420030bf504bcd524"
    sha256 cellar: :any_skip_relocation, monterey:       "18e520db93a4ec9da088b26e877aed6f678c4d5eb1e1fa23c7d607a1cd8d5a82"
    sha256 cellar: :any_skip_relocation, big_sur:        "abda672de18fdc778a01f0aafa1bf2a9108fd1df2662afff7f849dafafa855d4"
    sha256 cellar: :any_skip_relocation, catalina:       "fccdb14eb1a620c824c08e748db390d788ad797c30654cb6434205fb16c78784"
    sha256 cellar: :any_skip_relocation, mojave:         "798de4490c97283280259ffc1dc39159bd0ded85edb47f3212ad5ec9a174289e"
    sha256 cellar: :any_skip_relocation, high_sierra:    "fdb2a72157445c33a462388f05580489c427f4f0d2a3d4cdc1b7867ef69e7e53"
    sha256 cellar: :any_skip_relocation, sierra:         "4ef3590e26c5ac96d64dc985b035ec7055f215c84d31dfb09542d958f6ec4e77"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "29cac996baf6556c934e02bc94147f051107656945dee2b35284601b67c5e50f"
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
