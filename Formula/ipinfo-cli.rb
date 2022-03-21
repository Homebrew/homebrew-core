class IpinfoCli < Formula
  desc "Official CLI for the IPinfo IP Address API"
  homepage "https://ipinfo.io/"
  url "https://github.com/ipinfo/cli/archive/ipinfo-2.8.0.tar.gz"
  sha256 "b46e533978e442656203122f42bee5917ba3ba388b579a1c0b7bd6ac02985ad1"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^ipinfo[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c638228a2813bfcc19801c6a60e496f07c5a81ee34778a62bbfe18062e356d80"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c125aedec8f6c463b050915752850a5d15b252ab82172d0218d4ee28b8f4a6ab"
    sha256 cellar: :any_skip_relocation, monterey:       "4ea446ae2609603adcc1fa9d269426caf532bcc7ab0b5aab3bf947f29d292c15"
    sha256 cellar: :any_skip_relocation, big_sur:        "1026f638c931c73168aea6f5204379be692396fb1581b4bdf795fd92dcc6cc47"
    sha256 cellar: :any_skip_relocation, catalina:       "fbec01b67843e3e19db72c4a62d57b3227c8b3aaa71a626a7b2a34f4712385fc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3f4199bb0e83f72182953bd2bf21da497091c293b4bfaa720d2b3e4e50c6ecd9"
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
