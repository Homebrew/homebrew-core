class Libmtp < Formula
  desc "Implementation of Microsoft's Media Transfer Protocol (MTP)"
  homepage "https://libmtp.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/libmtp/libmtp/1.1.20/libmtp-1.1.20.tar.gz"
  sha256 "c9191dac2f5744cf402e08641610b271f73ac21a3c802734ec2cedb2c6bc56d0"
  license "LGPL-2.1-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "118e7f397a4f0cce6ec3ec22b0f881a29db2ac1dc7cedf6b6efc15aef00b8727"
    sha256 cellar: :any,                 arm64_monterey: "5f786718e8113e58a7f194e32748f3bd6b07899514e7e2190d8262c0843ca3ce"
    sha256 cellar: :any,                 arm64_big_sur:  "c4b3e59f86dae97b5fc0774e384ad4ad5e6f13fab5e9b03ab586b0de8774e0ad"
    sha256 cellar: :any,                 ventura:        "98613b0977d4fe565700e6b07ae7f7b63f57fcd9ab50bf0af0d5b4ec6dc2c2f9"
    sha256 cellar: :any,                 monterey:       "822134a5c60cfcfd2781d2c897b06b790aec731c996ba081d032477008ab793c"
    sha256 cellar: :any,                 big_sur:        "97fa5291b656454e4ac9c174fc08e93045ecd33f8d02a69d103c33a6e1e4a669"
    sha256 cellar: :any,                 catalina:       "76e0242398cee340b4d1d693ddf2d855bb6e4dfa04e5f8d7f420cac8ccf54ccc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2d96f04445b409a18583b8ad5bd316a36d38c7904eda472a2d0a038071ac058f"
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
