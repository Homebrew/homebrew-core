class Monit < Formula
  desc "Manage and monitor processes, files, directories, and devices"
  homepage "https://mmonit.com/monit/"
  url "https://mmonit.com/monit/dist/monit-6.0.0.tar.gz"
  sha256 "ddacd2a8120aeb2351e4486ee04a17782b5004aee99f2041d829bc4dcf2a5b3b"
  license "AGPL-3.0-or-later"
  revision 1

  livecheck do
    url "https://mmonit.com/monit/dist/"
    regex(/href=.*?monit[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "e71a6a2deb67c965d5d7348c1682c51608ce7559141db08c22ded93ec42210a5"
    sha256 cellar: :any, arm64_tahoe:       "477331b19fc0b1cf7f425b2634ed2a214246b4dbf5c4a303096580af03e90f1e"
    sha256 cellar: :any, arm64_sequoia:     "fa7d02a81004e486c5165dcbe9cd7411310f43b7a90d2c6a06966fbf920cb7f4"
    sha256 cellar: :any, arm64_linux:       "17d2a2d43398ffd40ba1f436abbe4363733d27dafdcd86995fd31cae3b717515"
    sha256 cellar: :any, x86_64_linux:      "f357307da065b779ff93bceef3d314403bd20841fef4393a3ff42f438a542fba"
  end

  depends_on "openssl@4"

  uses_from_macos "libxcrypt"

  on_linux do
    depends_on "linux-pam"
    depends_on "zlib-ng-compat"
  end

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--localstatedir=#{var}/monit",
                          "--sysconfdir=#{etc}/monit",
                          "--with-ssl-dir=#{formula_opt_prefix("openssl@4")}"
    system "make"
    system "make", "install"
    etc.install "monitrc"
  end

  service do
    run [opt_bin/"monit", "-I", "-c", etc/"monitrc"]
  end

  test do
    system bin/"monit", "-c", "#{etc}/monitrc", "-t"
  end
end
