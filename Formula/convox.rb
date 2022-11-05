class Convox < Formula
  desc "Command-line interface for the Convox PaaS"
  homepage "https://convox.com/"
  url "https://github.com/convox/convox/archive/3.7.0.tar.gz"
  sha256 "fe6a58482b7071f4885f881a3f9674ac7c97017e249c48636fcb93971ad381ef"
  license "Apache-2.0"
  version_scheme 1

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "94d55baf1ab948c23d6dd6fb3d008e8f6cc0f73ae828e6a9255223cae187c80a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f8de6a863f89e713236ec2add494f211957aa83a83370f59f525bec8fcecddf3"
    sha256 cellar: :any_skip_relocation, monterey:       "1f0a944538b20d2ff004f283db304ec042b49f0a5ae11466e697165f4fb6896d"
    sha256 cellar: :any_skip_relocation, big_sur:        "0f4fd096aaa0ce98fff9c316b22bfcda25a9430fd845b416f922f99bd4a321d7"
    sha256 cellar: :any_skip_relocation, catalina:       "814817f533ce4617cb263188d80abb6e42c513694c0819943fe258b497397abc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6787cb1986eccefc56b7e68a835199e00fbce782d7fd444593454486fd6f2afa"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
    ]

    system "go", "build", "-mod=readonly", *std_go_args(ldflags: ldflags), "./cmd/convox"
  end

  test do
    assert_equal "Authenticating with localhost... ERROR: invalid login\n",
      shell_output("#{bin}/convox login -t invalid localhost 2>&1", 1)
  end
end
