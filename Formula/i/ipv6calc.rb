class Ipv6calc < Formula
  desc "Small utility for manipulating IPv6 addresses"
  homepage "https://www.deepspace6.net/projects/ipv6calc.html"
  url "https://github.com/pbiering/ipv6calc/archive/refs/tags/4.4.0.tar.gz"
  sha256 "6863540b173804e5b99cb2c1b14e600170ce9af0b462fcad41584c316d19a310"
  license "GPL-2.0-only"

  # Upstream creates stable version tags (e.g., `v1.2.3`) before a release but
  # the version isn't considered to be released until a corresponding release
  # is created on GitHub, so it's necessary to use the `GithubLatest` strategy.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4daa29d6f6455a38c28aec5cb43b1fa6ff27c6af63b60971c50afbe72f414e27"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4852ec0aa4940b225faffc6d51decab12dee509581a40b20b0cc40b2b0bcef30"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c79ec4f2970d30d6fffaab8bb45820d4586dd335780adc5429893e079cbca198"
    sha256 cellar: :any_skip_relocation, sonoma:        "3f4267c63a895aea520e08173811d432632307539e753084e4c54036addf77ea"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e2d306270bd9d41949603264becb27b5b0af71030b7f3221ca6b210bc54b4f42"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f3df1923853f9b43baf1eba4f9c028aea9d028c0d7329540d3c78db2380f5e06"
  end

  uses_from_macos "perl"

  def install
    system "./configure", *std_configure_args
    system "make"
    system "make", "install"
  end

  test do
    assert_equal "192.168.251.97",
      shell_output("#{bin}/ipv6calc -q --action conv6to4 --in ipv6 2002:c0a8:fb61::1 --out ipv4").strip
  end
end
