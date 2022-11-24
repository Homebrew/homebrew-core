class Advancecomp < Formula
  desc "Recompression utilities for .PNG, .MNG, .ZIP, and .GZ files"
  homepage "https://www.advancemame.it/comp-readme.html"
  url "https://github.com/amadvance/advancecomp/releases/download/v2.4/advancecomp-2.4.tar.gz"
  sha256 "911133b8bdebd43aa86379e19584112b092459304401a56066e964207da423a5"
  license "GPL-3.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d6cdc0557059ffac0375d3871cd6b7b2ef42011e4673e56d8dfd65cd5906bcb1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a486fc6020f1bf64e1475da126ba96ef25076ea7ebcf3814180ec02ea0bbabf6"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9bd1c6206332feed781e01cfbe38c664e8da1dca5574b372ec77534122c5be1e"
    sha256 cellar: :any_skip_relocation, ventura:        "7177142972a37c5e1c98ae2615a8f85b459151ddd8f68c6389c4a63a67787750"
    sha256 cellar: :any_skip_relocation, monterey:       "5a4b0b19ef83ce323382f329ee05eea2921ffcf0d76b8b92eb57addf765d14df"
    sha256 cellar: :any_skip_relocation, big_sur:        "cb543f503c1cda8dd04e317abed3c0403e06a82cff10ee3779da3dd06fd17d06"
    sha256 cellar: :any_skip_relocation, catalina:       "05ae73592833536fc37e4334e69b4ea3e28bbb9278ef6639cdcf44bb38c3d694"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1046eaa225b7aee0a421b32ec6fc7827d9b676739a96aa0df1c7e94f4766ff4a"
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
