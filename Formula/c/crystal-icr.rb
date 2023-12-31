class CrystalIcr < Formula
  desc "Interactive console for Crystal programming language"
  homepage "https://github.com/crystal-community/icr"
  url "https://github.com/crystal-community/icr/archive/refs/tags/v0.9.0.tar.gz"
  sha256 "2530293e94b60d69919a79b49e83270f1462058499ad37a762233df8d6e5992c"
  license "MIT"
  revision 3

  bottle do
    sha256 arm64_sonoma:   "b9e39b78791f3c162778961e2f5e94cf5c607c5a0e644738f0a8834953e610cc"
    sha256 arm64_ventura:  "3e306b04a87cc2ff6ac4519e60af5bbf898eff764670a4fb7a32ce18fa356c58"
    sha256 arm64_monterey: "ac908c4ff46211bce0b3fd185d692331ce01c330fd1f0f17f3c38cc2232d4c44"
    sha256 sonoma:         "150def9ae7b020da97e8f7480c96b5ef180c61c49d4e283f2d90d33938f66660"
    sha256 ventura:        "0696f4b5e1f24bd249db3c0e1599bf0d5d6370f6403404f4bc92c0ae9d5248b9"
    sha256 monterey:       "36938daa0cefeedd1d7e6a50fa94d2e970a181e4a9f01f42a169bca8e72eef8c"
    sha256 x86_64_linux:   "5e1918682e133a6980b4a0e9284ef4aa60cbd6253da43bf06cf73ae96ceab4eb"
  end

  depends_on "crystal"
  depends_on "libevent"
  depends_on "libyaml"
  depends_on "openssl@3"
  depends_on "readline"

  def install
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    assert_match "icr version #{version}", shell_output("#{bin}/icr -v")
  end
end
