class Mfcuk < Formula
  desc "MiFare Classic Universal toolKit"
  homepage "https://github.com/nfc-tools/mfcuk"
  url "https://storage.googleapis.com/google-code-archive-downloads/v2/code.google.com/mfcuk/mfcuk-0.3.8.tar.gz"
  sha256 "977595765b4b46e4f47817e9500703aaf5c1bcad39cb02661f862f9d83f13a55"
  license "GPL-2.0-or-later"
  revision 1

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:    "d64c65224a51793f1dd148741d3750dfed188a452c99793321837ee4e6ff98e0"
    sha256 cellar: :any,                 arm64_sequoia:  "102426161778216f2bf11462bbaa8bb369a883cc818b560491d85bc5307ef9d9"
    sha256 cellar: :any,                 arm64_sonoma:   "b607795d4f69c5e9a8b6cb6b6017411e8acff391b71ea51e86229352a9ea4a91"
    sha256 cellar: :any,                 arm64_ventura:  "c9ab885a21f8102b6a0f9256a565f35a2501a635880bc9e0f6aaf07c766fe97f"
    sha256 cellar: :any,                 arm64_monterey: "7b5be1129fc0bd29968d0c863391b101892525aacb5146316095066a87c652aa"
    sha256 cellar: :any,                 arm64_big_sur:  "f37625d6d5f84b70a6e85359da444790d64a56f898c8051c41f314ad061cbc42"
    sha256 cellar: :any,                 sonoma:         "f9b5beef9f7da2eebc104e24cd3fa5021a0cd0b5a592931f7ca8e7e90ededffb"
    sha256 cellar: :any,                 ventura:        "c126f3f7da887cb15754a7e9ac59cd9f70bebb9bca2d4a931395a4bcdea9895e"
    sha256 cellar: :any,                 monterey:       "fb3c96007c69c0b301d8dbe1d4c05b21e5ecfe16927e18cdc8d8e3d1179f8ae6"
    sha256 cellar: :any,                 big_sur:        "0da7f4ed6a6b71a7960274fc7f020510d289269d6a3ed1e8f84f884a2619a684"
    sha256 cellar: :any,                 catalina:       "c9191edf0484422fa432827e017d05d4854cde1fd8194a3735eec0e060884652"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "360682a51ff5e48899affc75b1fa66db90faf99ebdde7059cc0dce49f319bf03"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ce46cb3bb5f400139ff5e306dbdd76d4e1c0fe62acd3b9bc5711e3cc734ee835"
  end

  depends_on "pkgconf" => :build
  depends_on "libnfc"
  depends_on "libusb"

  def install
    system "./configure", *std_configure_args
    system "make"
    system "make", "install"
  end

  test do
    system bin/"mfcuk", "-h"
  end
end
