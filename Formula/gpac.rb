# Installs a relatively minimalist version of the GPAC tools. The
# most commonly used tool in this package is the MP4Box metadata
# interleaver, which has relatively few dependencies.
#
# The challenge with building everything is that Gpac depends on
# a much older version of FFMpeg and WxWidgets than the version
# that Brew installs

class Gpac < Formula
  desc "Multimedia framework for research and academic purposes"
  homepage "https://gpac.wp.mines-telecom.fr/"
  url "https://github.com/gpac/gpac/archive/v1.0.1.tar.gz"
  sha256 "3b0ffba73c68ea8847027c23f45cd81d705110ec47cf3c36f60e669de867e0af"
  license "LGPL-2.1-or-later"
  head "https://github.com/gpac/gpac.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "9ec6267f802e1c30d49e095425ad12794d4ad84382b872c54249c42adbe8de33"
    sha256 cellar: :any,                 arm64_monterey: "74f3336aa8d6f9cfc15c19ddd56a855adae55546875f113d95ac1be249688119"
    sha256 cellar: :any,                 arm64_big_sur:  "9d969e1cab82b163e4958a99e7e73f89fcf7a10675626223c5d4be1fc3b7d427"
    sha256 cellar: :any,                 ventura:        "e0e47e419773dbc923288b989c3cc6540d6f17d9b6c1b60d9ccd265c9fe51173"
    sha256 cellar: :any,                 monterey:       "283c472be56974de1c4d1a7ea733e2616621a3294ff771be200d170b3dd0b3ce"
    sha256 cellar: :any,                 big_sur:        "f6c4c5413b6746988520e5d9b1f0ee584f7456b208ed994e87fa8675436c9c41"
    sha256 cellar: :any,                 catalina:       "cd323eba25dac7431970a3854c1317c1e4ce71e12421a1c789bfe127f2c373d7"
    sha256 cellar: :any,                 mojave:         "f6acea4aee0a0719ae5c8deb775529a07a7da5d8e32e9c30371a7165b010294d"
    sha256 cellar: :any,                 high_sierra:    "b050e13507f1462dcf37d968ed24e36195cf6026dc762e7ddbfa7de9088e0a9c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "57e4c20420fd7043ccd8f9c1851453df9023065271a540c55ba837f0249d9cce"
  end

  depends_on "pkg-config" => :build
  depends_on "openssl@1.1"

  uses_from_macos "zlib"

  conflicts_with "bento4", because: "both install `mp42ts` binaries"

  def install
    args = %W[
      --disable-wx
      --disable-pulseaudio
      --prefix=#{prefix}
      --mandir=#{man}
      --disable-x11
    ]

    system "./configure", *args
    system "make"
    system "make", "install"
  end

  test do
    system "#{bin}/MP4Box", "-add", test_fixtures("test.mp3"), "#{testpath}/out.mp4"
    assert_predicate testpath/"out.mp4", :exist?
  end
end
