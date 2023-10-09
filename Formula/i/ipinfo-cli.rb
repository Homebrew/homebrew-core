class IpinfoCli < Formula
  desc "Official CLI for the IPinfo IP Address API"
  homepage "https://ipinfo.io/"
  url "https://github.com/ipinfo/cli/archive/refs/tags/ipinfo-3.1.2.tar.gz"
  sha256 "ac3bb31071ab7a68b09429dbe878ea88085dd9ff1729909b33f129d0a6e2b429"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^ipinfo[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "349ac2924978d0c131180a5fcb512340355e8b2fd82fb19cf69e9507acc7f526"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "187ab871825515467e9bc7b36f11ab57a3713050a99e0ea1473c3d2bcefba74b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "dfee52c914dd93f4eceb74d83d6f945787a5933f93578c4583ef53fa764e8c77"
    sha256 cellar: :any_skip_relocation, sonoma:         "4cc6119e04bee88f54902562e5be1b8e7eb045cc7eb1a63f6f1e7b266e76bb9f"
    sha256 cellar: :any_skip_relocation, ventura:        "f63a01b188e94ac1d408cf6b1f66b0a009bd643e8f5bca11c12126f2ccca3a9e"
    sha256 cellar: :any_skip_relocation, monterey:       "5f048c9190d475fdea23fc5b9cab27526e3aa935e587490f467119c00b9c1ecd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0daf34f0b2604660740b560dc6a020f08c5822edab6fa57f208ba2b7a358e28b"
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
