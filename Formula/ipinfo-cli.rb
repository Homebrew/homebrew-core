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
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8c5c055181e59a39b61d5a8c76533348f0efc92ead6a7b3e48df79e0412f2c72"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ac0514f75e0c1b66fc9ad7d63d073931a3cea775b0a45a11bb42a065c1263a40"
    sha256 cellar: :any_skip_relocation, monterey:       "28fb7b3985c6438047f1c5a79152b0d8260703d936b0e104fdde19c1d529e14c"
    sha256 cellar: :any_skip_relocation, big_sur:        "40150706085bb0b225a4ce44cb1f58dada65afbb0c097680f95d33e562dc0546"
    sha256 cellar: :any_skip_relocation, catalina:       "f1890bd27433d2f80d7ac79302de26ed6d84d94615a756c23d3da75a19f6a5e0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8c049f7304553fdddb1eb23cd98dfbf463b66db75c497ab308f5a3d1489515b9"
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
