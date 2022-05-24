class Advancecomp < Formula
  desc "Recompression utilities for .PNG, .MNG, .ZIP, and .GZ files"
  homepage "https://www.advancemame.it/comp-readme.html"
  url "https://github.com/amadvance/advancecomp/releases/download/v2.3/advancecomp-2.3.tar.gz"
  sha256 "811f661dfbbdddefdcb5eaf133e403ca2af99328b850b22c1249f7bebe657578"
  license "GPL-3.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a5b487926943d347aa3cdc87e602bcad83d22762d525a1cdf87beb1b9426537c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a7e799efa5b2d75d1be52435b8bfd2e1299e4603f3a0253ad85209997b0d3920"
    sha256 cellar: :any_skip_relocation, monterey:       "2902fd231ffd1a2f074a82e759fb56597926cf11909aaacedbbea1316813dba7"
    sha256 cellar: :any_skip_relocation, big_sur:        "3015ac210486e65470e94fd9265cc275ba3a5bc1680cc554d9d3a3c59962bb63"
    sha256 cellar: :any_skip_relocation, catalina:       "7a68d4c277ffb224d694bd6a41db6824c0253acea729068ed3accf086f99b7bb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5489c25165ab09c33ca21ed0ffcb5a3cb708a9a98773f9f1260d69f25e85b383"
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
