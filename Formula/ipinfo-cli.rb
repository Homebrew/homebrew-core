class IpinfoCli < Formula
  desc "Official CLI for the IPinfo IP Address API"
  homepage "https://ipinfo.io/"
  url "https://github.com/ipinfo/cli/archive/ipinfo-2.1.1.tar.gz"
  sha256 "136e08ae35eb5b7ba6d4c5ff97c2b4aa342f87a4e53d088cd40c290df3bd9fc1"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^ipinfo[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "b00dabc143ee2301b952774b60b2d178f4ec6f2ac80ea26119f3776444f2734e"
    sha256 cellar: :any_skip_relocation, big_sur:       "448a4e1aa0da2d405e9e1d2ef9c22a8f676cc80d6ed73c7a2e7cdac6a967ef3d"
    sha256 cellar: :any_skip_relocation, catalina:      "c26fd18395a62ea85fce86d26599fe5063af58c3c175ffb795236628497df443"
    sha256 cellar: :any_skip_relocation, mojave:        "36c4c0c130fe5331d5593313b00266831fd0665d4bf8bb38604d32e2643e1390"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c790566eaa4aaafb10eecf842849df5444edaf40d1db4e62915f17d277611203"
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
