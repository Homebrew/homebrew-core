class CrystalIcr < Formula
  desc "Interactive console for Crystal programming language"
  homepage "https://github.com/crystal-community/icr"
  url "https://github.com/crystal-community/icr/archive/v0.9.0.tar.gz"
  sha256 "2530293e94b60d69919a79b49e83270f1462058499ad37a762233df8d6e5992c"
  license "MIT"
  revision 1

  bottle do
    sha256 arm64_ventura:  "b58c044412b4da53700db5e4626eb6ddb89d311e85b115a2f9d0a7f5d1f39006"
    sha256 arm64_monterey: "3ba98afa66a8f387d858371e3b201c05b7f8d27f90d09a40fc09c8062b291097"
    sha256 arm64_big_sur:  "0b5e88e36a88de2b9088fc19bfc6541088e3c9cbefdf925d31dd71e0a671c09b"
    sha256 ventura:        "71e6ef38ccc87c98bdeb0270c0dac7288b7f04071c0a10ab41fd81a58ef02699"
    sha256 monterey:       "d6de676dcd2da4d83a87c5048b3a5e696ad29807e311fee3751c20f220e11eee"
    sha256 big_sur:        "d1759c54fe2ebe6be91efc03e45ed67f9a549a3725943c31c62499135d0f19d5"
    sha256 x86_64_linux:   "ccfa6a169b35abb5e61ea1938a366cc3e75b8c4098dc1352068c288b21358873"
  end

  depends_on "crystal"
  depends_on "libevent"
  depends_on "libyaml"
  depends_on "openssl@1.1"
  depends_on "readline"

  def install
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    assert_match "icr version #{version}", shell_output("#{bin}/icr -v")
  end
end
