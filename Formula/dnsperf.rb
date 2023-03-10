class Dnsperf < Formula
  desc "Measure DNS performance by simulating network conditions"
  homepage "https://www.dns-oarc.net/tools/dnsperf"
  url "https://www.dns-oarc.net/files/dnsperf/dnsperf-2.11.1.tar.gz"
  sha256 "3aad445f754f0c4e98c54c8595d54f75e98314dfd3570467281c25bba100541e"
  license "Apache-2.0"

  livecheck do
    url :homepage
    regex(/href=.*?dnsperf[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "08f02832d8d8ed1dc5194766647be268d7c58b617dfce050ec895fa9080072a9"
    sha256 cellar: :any,                 arm64_monterey: "775b82eeb455b4d8ac8c7a7eb71281bac43e8a8c88bfa5a19c4cd63d1e106aef"
    sha256 cellar: :any,                 arm64_big_sur:  "1f2b6645db101e8c6c9f7673f65b13a60fd28a47bde3f8a778a2d7c980fe6775"
    sha256 cellar: :any,                 ventura:        "755ab3905609fb3c553272660c3b96329ec0f383c3c8486a9904671ed890a943"
    sha256 cellar: :any,                 monterey:       "9532e38438e6b40da05028c7afcac6153b54fc822bf0e84ff6f1632795362a3b"
    sha256 cellar: :any,                 big_sur:        "6df17561c20cfca64ff8516d14ba0b0b2e67ce378b2fecb97c25152d41c779e8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "addeaf1ff75d2935cc57affe50f3eb16d86f02c81af216296db7f26da3c71b78"
  end

  depends_on "pkg-config" => :build
  depends_on "concurrencykit"
  depends_on "ldns"
  depends_on "libnghttp2"
  depends_on "openssl@1.1"

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    system "#{bin}/dnsperf", "-h"
    system "#{bin}/resperf", "-h"
  end
end
