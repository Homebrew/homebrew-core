class Dnsperf < Formula
  desc "Measure DNS performance by simulating network conditions"
  homepage "https://www.dns-oarc.net/tools/dnsperf"
  url "https://www.dns-oarc.net/files/dnsperf/dnsperf-2.15.1.tar.gz"
  sha256 "4d64264fe407057b5b84d6a2c4c7632cf9b84fe0aeebe8989d1017fb1b5f87b5"
  license "Apache-2.0"

  livecheck do
    url :homepage
    regex(/href=.*?dnsperf[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "0f088943d0870bb1000bef9ec9ff97ca7c8d12baa8e46c2f91380be7ac7beffc"
    sha256 cellar: :any,                 arm64_sequoia: "2e652107be3639453d1605b96f2434728aefbe89cde9ae9a61ece38338f6a0d8"
    sha256 cellar: :any,                 arm64_sonoma:  "0054b3c63f708e3a21d423e66c1eb4884f3d96d2f8b0dfeb12bb802bd07bd73b"
    sha256 cellar: :any,                 sonoma:        "1eb2ca2125aec8cf6df26a7d7b30394457766c97a9175c88f121c23ec039f150"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4133a1360f1a961e9ef7ffd0c26535eec60e5a84fbefe3212c20b3d8e988adf0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1f0cbac5bd303d01ae4ec1839a56c7ec6963b47990a25d6ab05b454c430e0516"
  end

  depends_on "pkgconf" => :build
  depends_on "concurrencykit"
  depends_on "ldns"
  depends_on "libnghttp2"
  depends_on "openssl@3"

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    system bin/"dnsperf", "-h"
    system bin/"resperf", "-h"
  end
end
