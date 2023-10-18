class Libmtp < Formula
  desc "Implementation of Microsoft's Media Transfer Protocol (MTP)"
  homepage "https://libmtp.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/libmtp/libmtp/1.1.21/libmtp-1.1.21.tar.gz"
  sha256 "c4ffa5ab8c8f48c91b0047f2e253c101c418d5696a5ed65c839922a4280872a7"
  license "LGPL-2.1-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "e5fcc63cb5a7c844f964a1bca0e6e55f072d0d117bfcc2b7683e0d1bab4e39b2"
    sha256 cellar: :any,                 arm64_ventura:  "e410f7a6dab05b9bf74a0c179450d8e563f60802a2789da986841dcefd493f56"
    sha256 cellar: :any,                 arm64_monterey: "f0127838120cb34a56434b2ff8b267f4f280cbb2d06ab48fb959d0f641e92f13"
    sha256 cellar: :any,                 arm64_big_sur:  "a247cada4841c6a16d507ab969cf60f31dab5cd91f94d10a8a390be3b02df110"
    sha256 cellar: :any,                 sonoma:         "4d46d38ea7378ab959fc439310264ab5ed42377729185d694406654fb5ff8b2a"
    sha256 cellar: :any,                 ventura:        "af43ad4feaf03b0c822219131261fb5d24a2bebf39c198778229d9488c1040cd"
    sha256 cellar: :any,                 monterey:       "330cb763b3a708340527235e892a0b45e086bdc559021ad7b06b6e9c230be21c"
    sha256 cellar: :any,                 big_sur:        "65dff5ee98c8f7701e2b2e646509ac37a2420d07f384f762e4653c6f526f0ecd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b2c0baeb49e12c024050db966e3e8f9562131eed2a378ff29c0ed04e51ba812e"
  end

  depends_on "pkg-config" => :build
  depends_on "libusb-compat"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--disable-mtpz",
                          "--with-udev=#{lib}/udev"
    system "make", "install"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mtp-getfile")
  end
end
