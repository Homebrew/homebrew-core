class Dnsperf < Formula
  desc "Measure DNS performance by simulating network conditions"
  homepage "https://www.dns-oarc.net/tools/dnsperf"
  url "https://www.dns-oarc.net/files/dnsperf/dnsperf-2.15.0.tar.gz"
  sha256 "3dc72200a59e71c47409abfd5613aad4d24d89c310033abfdb230cdcca599277"
  license "Apache-2.0"

  livecheck do
    url :homepage
    regex(/href=.*?dnsperf[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "bbd032ada85a45e63eb0d63f7aaeccb80d8e2316c421787af76067f4806bb1c8"
    sha256 cellar: :any,                 arm64_sequoia: "6472cd750e0f6891051899fc05b1cee8efa70e564e2f3f72b696d038ed75f8b2"
    sha256 cellar: :any,                 arm64_sonoma:  "5c72ae5dfb750bd0521c68b1f34b52f8defc98368ffddf00c275dca6abbf0ad3"
    sha256 cellar: :any,                 sonoma:        "cca71266489cb7a05daed9ce26259b8f6f642173520416806c47dfcd3e108ddd"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e87613432cc0c7bda9c6b274df354036adbc40472292d0b16996b03748d12de9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dd1c17be41d2662d51d9e6b3c40db9275f28f1186d23f422ce873c3dd2ee4b6a"
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
