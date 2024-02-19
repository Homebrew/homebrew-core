class IpinfoCli < Formula
  desc "Official CLI for the IPinfo IP Address API"
  homepage "https://ipinfo.io/"
  url "https://github.com/ipinfo/cli/archive/refs/tags/ipinfo-3.3.0.tar.gz"
  sha256 "18069e115c78a7a167311ad02de354c8e8d71dc63d838d94635f439eb64585f0"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^ipinfo[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "6a890ab424c2003b2c1041317c08de00c4161f6d878c33e247bd1030496ed7b3"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ea2ff859451743f1d01b2c76295e3dfcd0604777fb033451ac4b5716be3e2050"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "64dc809280e977531f34dd74d4546ffee2cb45efbe9ee8de8c08b8ffa1d3f6ee"
    sha256 cellar: :any_skip_relocation, sonoma:         "ad244ae0fd693a2d0844b23d80f1cfdf487906b2e379ec4e26bc340793d50712"
    sha256 cellar: :any_skip_relocation, ventura:        "4daed60eef138ab905420d0dfc3536dadd0b09f51da719ddf66c9d723f60a0c3"
    sha256 cellar: :any_skip_relocation, monterey:       "0d00f4343d1d8d140ebf6b8781e6c637abfea9895d1303adb5aef66a06ae3753"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e55c905ca88062290d6843685d6d5506ed34448da276beac34b0e191cfd7b982"
  end

  depends_on "go" => :build

  conflicts_with "ipinfo", because: "ipinfo and ipinfo-cli install the same binaries"

  def install
    system "./ipinfo/build.sh"
    bin.install "build/ipinfo"
    generate_completions_from_executable(bin/"ipinfo", "completion")
  end

  test do
    assert_equal version.to_s, shell_output("#{bin}/ipinfo version").chomp
    assert_equal "1.1.1.0\n1.1.1.1\n1.1.1.2\n1.1.1.3\n", `#{bin}/ipinfo prips 1.1.1.1/30`
  end
end
