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
    sha256 cellar: :any_skip_relocation, arm64_monterey: "389a8aa89033d3da4ddb6523e0ff0a14293517f39e0383b1141155e6ce40bb66"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "dacffa8138fb7493c03b49cb102b0212161200e20ee4c275d99cdf48c7ca95ed"
    sha256 cellar: :any_skip_relocation, monterey:       "4c163910bf2faeaa45481ac4c66a3de1c930ccfa0b35ad8e2396e32f684dd0e0"
    sha256 cellar: :any_skip_relocation, big_sur:        "1a04ef8842eee1a6dd348b4cbe4e78366040267d6c941a3b1325c078e6a6eb87"
    sha256 cellar: :any_skip_relocation, catalina:       "a93c6dc922bc76f820914e627493dd7c76d38de196f23839ed4ee341a1832f70"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a8205b64ef2260e492b68bedacd639c3f57dcf45444461bc5df3f3f12163f446"
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
