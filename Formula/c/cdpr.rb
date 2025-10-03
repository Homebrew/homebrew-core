class Cdpr < Formula
  desc "Cisco Discovery Protocol Reporter"
  homepage "https://www.monkeymental.com/"
  url "https://downloads.sourceforge.net/project/cdpr/cdpr/2.4/cdpr-2.4.tgz"
  sha256 "32d3b58d8be7e2f78834469bd5f48546450ccc2a86d513177311cce994dfbec5"
  license "GPL-2.0-or-later"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "82a48884ef52f0eac1769644d8efa9ee572031be613669d16b3b23c1e09f1393"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "dfd6f6ef21a6f1fbc38367d4000fdf6a6dd9910b5959bc7c418e2a89b94d1476"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "9a2af70f28e705ac6064aa5d51bb4fe7d00483b6588673768fef2239a516ffcf"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f35e7e9e3c93e119f7357b74debf967a8703ec468e1f73f7dd7ebb79220ba631"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "09f09ac98ad3c7e738e0d31bc9d37bdec2cd3745aa5d8d28db3953ef27541561"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f2818981f1d2a090f072741028fc22ca8b420f6956661678b2768311f11f7064"
    sha256 cellar: :any_skip_relocation, sonoma:         "cc072ad444adf7814675187844074684fcf33b12dc87e7044d6151864adbb40b"
    sha256 cellar: :any_skip_relocation, ventura:        "bb8bee00358b95fe993e2afb2af08573ead8e170b15f788fe96c8d23d4f186fd"
    sha256 cellar: :any_skip_relocation, monterey:       "6dd8c4aa87c35167d8fb95ed0e450da18e3697a3dd6cf28e50b443e872b4a104"
    sha256 cellar: :any_skip_relocation, big_sur:        "256d525f93fcdfb7f8c765ca45c6c3b422f00386045a9feb3bd99a083382c9c8"
    sha256 cellar: :any_skip_relocation, catalina:       "62e58521757a1dd5020d962dc9a5d00647e920a66347b5d5e58c1e8920db822f"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "ea696f5689ebc5dd7ca3dfc9621e40da5ceb24b4016607c713a7f05d5de2a130"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6a2162fee06fc9c03e01a2a6787a18f1d8a0c241a0c315d76878b09ea787c7b6"
  end

  uses_from_macos "libpcap"

  def install
    # Work around failure from GCC 10+ using default of `-fno-common`
    # multiple definition of `timeout'; /tmp/ccw1Bjcf.o:(.bss+0x0): first defined here
    # multiple definition of `cdprs'; /tmp/ccw1Bjcf.o:(.bss+0x4): first defined here
    # multiple definition of `handle'; /tmp/ccw1Bjcf.o:(.bss+0x8): first defined here
    cflags = []
    cflags << "-fcommon" if OS.linux?

    # Makefile hardcodes gcc and other atrocities
    system ENV.cc, *cflags, "cdpr.c", "cdprs.c", "conffile.c", "-lpcap", "-o", "cdpr"
    bin.install "cdpr"
  end

  def caveats
    "run cdpr sudo'd in order to avoid the error: 'No interfaces found! Make sure pcap is installed.'"
  end

  test do
    system bin/"cdpr", "-h"
  end
end
