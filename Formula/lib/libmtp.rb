class Libmtp < Formula
  desc "Implementation of Microsoft's Media Transfer Protocol (MTP)"
  homepage "https://libmtp.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/libmtp/libmtp/1.1.23/libmtp-1.1.23.tar.gz"
  sha256 "74a2b6e8cb4a0304e95b995496ea3ac644c29371649b892b856e22f12a0bdeed"
  license "LGPL-2.1-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "6bd6b1027d7491cce853f34578cfecad1645e95c5002619c51f28e261122b7ba"
    sha256 cellar: :any,                 arm64_sequoia: "a8fccff1e5fb87a33287fdccd00ff301e97377a899db19e200b0101a40631c8b"
    sha256 cellar: :any,                 arm64_sonoma:  "e5cd66757ea323741414b6d0a52f8d5e29ed105d1ac35f8855484e655c90367c"
    sha256 cellar: :any,                 sonoma:        "8ee478d393d41ac7c4299fd2f8c0ba640307707a9c85910b326db3770b30439e"
    sha256                               arm64_linux:   "7379c6c656432162f854e5e6fd415564bf9d9f8469fca427709405653b82be30"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2f842da301974cc07cd11563aaace91d6259f244a507caa6b17ccd14951c1dc7"
  end

  depends_on "pkgconf" => :build
  depends_on "libusb"

  def install
    system "./configure", "--disable-mtpz",
                          "--disable-silent-rules",
                          "--with-udev=#{lib}/udev",
                          *std_configure_args
    system "make", "install"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mtp-getfile")
  end
end
