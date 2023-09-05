class IkeScan < Formula
  desc "Discover and fingerprint IKE hosts"
  homepage "https://github.com/royhills/ike-scan"
  url "https://github.com/royhills/ike-scan/archive/1.9.5.tar.gz"
  sha256 "5152bf06ac82d0cadffb93a010ffb6bca7efd35ea169ca7539cf2860ce2b263f"
  license "GPL-3.0-or-later" => { with: "openvpn-openssl-exception" }
  head "https://github.com/royhills/ike-scan.git", branch: "master"

  bottle do
    rebuild 1
    sha256 arm64_ventura:  "4962babb485008c4ca7365744527389c7f100c26a37e286f4131f554d8d30e76"
    sha256 arm64_monterey: "2cdc49f704f821bd0aaa51534c4d9b8b73524fae1737ca302308b026c4d48db9"
    sha256 arm64_big_sur:  "e3e644f24b55009f2acb78739cd2504f72800c07d3faac4fe2f8af7256b119a4"
    sha256 ventura:        "d75a804e64246fb47fa55b2b96cfe9ad00659b29f11c35b14eb182dd0dd0a298"
    sha256 monterey:       "a75856c7333e0bdfd2668348ed6abfbee95361f1e3645998c7730f84eecf45a1"
    sha256 big_sur:        "43fb51d3ef205224920eee1e85861d8957159684d86d3de76c925b3e14b22c87"
    sha256 catalina:       "a158c41e25fa99aaca6bf29573b4b6e77775be3402973bd016ee3ef4f9d6c8cc"
    sha256 x86_64_linux:   "2b7b0f9ab06373c381c2133befa3d9524bcdb27c6ccd0f44acdc52d5497cee24"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "openssl@3"

  def install
    system "autoreconf", "--force", "--install", "--verbose"
    system "./configure", *std_configure_args,
                          "--mandir=#{man}",
                          "--with-openssl=#{Formula["openssl@3"].opt_prefix}"
    system "make", "install"
  end

  test do
    # We probably shouldn't probe any host for VPN servers, so let's keep this simple.
    system bin/"ike-scan", "--version"
  end
end
