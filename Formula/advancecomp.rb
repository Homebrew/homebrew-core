class Advancecomp < Formula
  desc "Recompression utilities for .PNG, .MNG, .ZIP, and .GZ files"
  homepage "https://www.advancemame.it/comp-readme.html"
  url "https://github.com/amadvance/advancecomp/releases/download/v2.5/advancecomp-2.5.tar.gz"
  sha256 "90b8ecad387b4770658e85be850b22318ee9e375cbad85ad25c8519d93317c07"
  license "GPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0b9598446b49c1a66e9b6105bc4028093f67a80365a31ee3e64406e4d44d3050"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "40e3ba62c044d1b9d60f3e6088b66e99077370dd59b856871f71d8d6574142c8"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "20dce664facfa87a65d6b89e508bcc74163ea837cb0d6f2c5fc77b8377ff500b"
    sha256 cellar: :any_skip_relocation, ventura:        "f402ba3f6adf5d5583c64f5fd36dad1e782e1239f506695d77a632b9ac47c213"
    sha256 cellar: :any_skip_relocation, monterey:       "77f6f5c169b3868047e1b6beba37db560439a47726c47ad9135e56b7e55230cd"
    sha256 cellar: :any_skip_relocation, big_sur:        "1caf8f0abc594c118349f94d81e2bc736b9d89a0bcfdd00aa7504f178bceb974"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1d5786528998017c36abae0d3297e726bac1aae45ce008a4de522fe335feb52a"
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
