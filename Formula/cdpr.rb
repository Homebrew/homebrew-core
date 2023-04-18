class Cdpr < Formula
  desc "Cisco Discovery Protocol Reporter"
  homepage "http://www.monkeymental.com/"
  url "https://downloads.sourceforge.net/project/cdpr/cdpr/2.4/cdpr-2.4.tgz"
  sha256 "32d3b58d8be7e2f78834469bd5f48546450ccc2a86d513177311cce994dfbec5"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f35e7e9e3c93e119f7357b74debf967a8703ec468e1f73f7dd7ebb79220ba631"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "09f09ac98ad3c7e738e0d31bc9d37bdec2cd3745aa5d8d28db3953ef27541561"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f2818981f1d2a090f072741028fc22ca8b420f6956661678b2768311f11f7064"
    sha256 cellar: :any_skip_relocation, ventura:        "bb8bee00358b95fe993e2afb2af08573ead8e170b15f788fe96c8d23d4f186fd"
    sha256 cellar: :any_skip_relocation, monterey:       "6dd8c4aa87c35167d8fb95ed0e450da18e3697a3dd6cf28e50b443e872b4a104"
    sha256 cellar: :any_skip_relocation, big_sur:        "256d525f93fcdfb7f8c765ca45c6c3b422f00386045a9feb3bd99a083382c9c8"
    sha256 cellar: :any_skip_relocation, catalina:       "62e58521757a1dd5020d962dc9a5d00647e920a66347b5d5e58c1e8920db822f"
    sha256 cellar: :any_skip_relocation, mojave:         "ae75b31d4fb195d0735784d7fb86924821ad07dfc5c5b4ff91597f6e0ceb5fba"
    sha256 cellar: :any_skip_relocation, high_sierra:    "ce836a4189c94a1441cb417f36699fca01e3cf30b69bcc5a3ec8307c51d0f66e"
    sha256 cellar: :any_skip_relocation, sierra:         "c6603372329fd2dc0c60266b3f3eb6c9f7cc5c0ce7f351b05977ab39a18cde7c"
    sha256 cellar: :any_skip_relocation, el_capitan:     "0bdc868c9b11510e2d9e6551dee970c20406215153906d8bc42790d8510ac429"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6a2162fee06fc9c03e01a2a6787a18f1d8a0c241a0c315d76878b09ea787c7b6"
  end

  uses_from_macos "libpcap"

  def install
    # Makefile hardcodes gcc and other atrocities
    system ENV.cc, "cdpr.c", "cdprs.c", "conffile.c", "-lpcap", "-o", "cdpr"
    bin.install "cdpr"
  end

  def caveats
    "run cdpr sudo'd in order to avoid the error: 'No interfaces found! Make sure pcap is installed.'"
  end

  test do
    system "#{bin}/cdpr", "-h"
  end
end
