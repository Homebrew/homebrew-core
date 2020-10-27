class Mfcuk < Formula
  desc "MiFare Classic Universal toolKit"
  homepage "https://github.com/nfc-tools/mfcuk"
  url "https://storage.googleapis.com/google-code-archive-downloads/v2/code.google.com/mfcuk/mfcuk-0.3.8.tar.gz"
  sha256 "977595765b4b46e4f47817e9500703aaf5c1bcad39cb02661f862f9d83f13a55"
  license "GPL-2.0"
  revision 1

  bottle do
    cellar :any
    sha256 "c9191edf0484422fa432827e017d05d4854cde1fd8194a3735eec0e060884652" => :catalina
    sha256 "2540f3232f4220dac3cf296c43fea2f2582c71ab18037e9d0c047c4f1df39f71" => :mojave
    sha256 "f624f03ed0674915332412b50d0013a9495aece4b1ef773767024d11b8fd0d8c" => :high_sierra
  end

  depends_on "pkg-config" => :build
  depends_on "libnfc"
  depends_on "libusb"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    system bin/"mfcuk", "-h"
  end
end
