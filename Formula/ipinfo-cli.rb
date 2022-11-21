class IpinfoCli < Formula
  desc "Official CLI for the IPinfo IP Address API"
  homepage "https://ipinfo.io/"
  url "https://github.com/ipinfo/cli/archive/ipinfo-2.10.0.tar.gz"
  sha256 "b48e69f309647d1845c36c0176cf6c07e13b59ca443269df7e4d394838b72211"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^ipinfo[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "446be2f3e35fdaadab5feea464722b9acdc77c25aaeb8d2b3d6aaa5cdec59d42"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4465fd206bc4be4ceb809fe9f5ccd7d1933fdd65aadbd3f56eb58d0377d360b9"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2f78aaf21b5a8108e4fb1abb1c147649f1cc61c92f3e4aa45af9380bb97a0b12"
    sha256 cellar: :any_skip_relocation, ventura:        "5cf690cfe3f8007c72a8cdfc37e82f68c038e5aee93002e9252dc1f489a6f351"
    sha256 cellar: :any_skip_relocation, monterey:       "6973d57bedf653482204399b9603fd149e2b488f06fe6c306a8809f292c15c63"
    sha256 cellar: :any_skip_relocation, big_sur:        "b3244fcfe3baca2dc121c014e87d1ad8a37fe409cb561a7c4dca026982e8b719"
    sha256 cellar: :any_skip_relocation, catalina:       "0deda261830be48927c24f480210046671552b1b3d1f886a4110e9ab5c17860a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bfca249987b48abf03891252a1d5d86503e05ecab9f9c8db5c71a27103c28b4d"
  end

  depends_on "go" => :build

  conflicts_with "ipinfo", because: "ipinfo and ipinfo-cli install the same binaries"

  def install
    system "./ipinfo/build.sh"
    bin.install "build/ipinfo"
  end

  test do
    assert_equal version.to_s, shell_output("#{bin}/ipinfo version").chomp
    assert_equal "1.1.1.0\n1.1.1.1\n1.1.1.2\n1.1.1.3\n", `#{bin}/ipinfo prips 1.1.1.1/30`
  end
end
