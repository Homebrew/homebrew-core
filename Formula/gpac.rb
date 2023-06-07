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
  url "https://github.com/gpac/gpac/archive/v2.2.1.tar.gz"
  sha256 "8173ecc4143631d7f2c59f77e1144b429ccadb8de0d53a4e254389fb5948d8b8"
  license "LGPL-2.1-or-later"
  head "https://github.com/gpac/gpac.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "84caaba4b33c8046f76ae2cf6ab1bd0369a2bc041c6463e6c86850d1a153fca9"
    sha256 cellar: :any,                 arm64_monterey: "0252eb68072e6dd72b49ea34d9792b8f34d2b587ac65ee9aa9308dcd0b1b11d7"
    sha256 cellar: :any,                 arm64_big_sur:  "3f9fc83da06d66afb107b43961830acbbb804b64877d294c6dd70418b0a02dff"
    sha256 cellar: :any,                 ventura:        "3a63967e6126113d72426837783a78cdd58b0032cb1cf53d1c524d43988fdad3"
    sha256 cellar: :any,                 monterey:       "c7d10218587a68a9fa3bcfcc59be3925eb37b44fc50c0fada4dc696033f70f6c"
    sha256 cellar: :any,                 big_sur:        "b5c86134beff39a6899305c4afb3bc9ebe1b64ec4453fec75e0ab4753da3c331"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8b39ea72001336daba7879374298eec1c9efefa6ca7ba1e7ee45b624b6464233"
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
