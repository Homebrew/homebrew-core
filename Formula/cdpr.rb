class Cdpr < Formula
  desc "Cisco Discovery Protocol Reporter"
  homepage "http://www.monkeymental.com/"
  url "https://downloads.sourceforge.net/project/cdpr/cdpr/2.4/cdpr-2.4.tgz"
  sha256 "32d3b58d8be7e2f78834469bd5f48546450ccc2a86d513177311cce994dfbec5"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "09f09ac98ad3c7e738e0d31bc9d37bdec2cd3745aa5d8d28db3953ef27541561"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f2818981f1d2a090f072741028fc22ca8b420f6956661678b2768311f11f7064"
    sha256 cellar: :any_skip_relocation, monterey:       "6dd8c4aa87c35167d8fb95ed0e450da18e3697a3dd6cf28e50b443e872b4a104"
    sha256 cellar: :any_skip_relocation, big_sur:        "256d525f93fcdfb7f8c765ca45c6c3b422f00386045a9feb3bd99a083382c9c8"
    sha256 cellar: :any_skip_relocation, catalina:       "62e58521757a1dd5020d962dc9a5d00647e920a66347b5d5e58c1e8920db822f"
    sha256 cellar: :any_skip_relocation, mojave:         "ae75b31d4fb195d0735784d7fb86924821ad07dfc5c5b4ff91597f6e0ceb5fba"
    sha256 cellar: :any_skip_relocation, high_sierra:    "ce836a4189c94a1441cb417f36699fca01e3cf30b69bcc5a3ec8307c51d0f66e"
    sha256 cellar: :any_skip_relocation, sierra:         "c6603372329fd2dc0c60266b3f3eb6c9f7cc5c0ce7f351b05977ab39a18cde7c"
    sha256 cellar: :any_skip_relocation, el_capitan:     "0bdc868c9b11510e2d9e6551dee970c20406215153906d8bc42790d8510ac429"
    sha256 cellar: :any_skip_relocation, yosemite:       "3f0fbd6fe9862b367f64354ad6ce3b2deacd35ae627f8d73d5095739325be378"
  end

  def install
    # Makefile hardcodes gcc and other atrocities
    system ENV.cc, ENV.cflags, "cdpr.c", "cdprs.c", "conffile.c", ENV.ldflags, "-lpcap", "-o", "cdpr"
    bin.install "cdpr"
  end

  def caveats
    "run cdpr sudo'd in order to avoid the error: 'No interfaces found! Make sure pcap is installed.'"
  end

  test do
    system "#{bin}/cdpr", "-h"
  end
end
