class Ipv6calc < Formula
  desc "Small utility for manipulating IPv6 addresses"
  homepage "https://www.deepspace6.net/projects/ipv6calc.html"
  url "https://github.com/pbiering/ipv6calc/archive/refs/tags/4.3.2.tar.gz"
  sha256 "4335c4edf7d51dbd0cafdd42ecda5598101f7a8ab257a74be2d9ec81f5bf895b"
  license "GPL-2.0-only"

  # Upstream creates stable version tags (e.g., `v1.2.3`) before a release but
  # the version isn't considered to be released until a corresponding release
  # is created on GitHub, so it's necessary to use the `GithubLatest` strategy.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6d69c91dd743db79707a31234f1efa0e1961469739e4f19726c373f2eef85794"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4810da640d3cd8b97576cf965ec8c711551434c8deb7833a30b93803528b383e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "795b64c67e622b3c16b2b92dac5792c33b96c2c3076ae1e57eecefd5624e3187"
    sha256 cellar: :any_skip_relocation, sonoma:        "e1e6e255927f430215d8342d57c6208f6f329a1400ab3cbc41e0ecf996bfd1cc"
    sha256 cellar: :any_skip_relocation, ventura:       "c21cbc228031fef73df1a7ed433eb14c7075c53906c6f3ac27b8b8695d93f5c7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a42d36fb49c632491409e0994f20fbc09abc923208b0147ee5ce4bc2ed5e24a1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "761116624949b91b5e89d1fbb17de07f93ae48f6387d14bc6a9a749ae664389c"
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
