class Convox < Formula
  desc "Command-line interface for the Convox PaaS"
  homepage "https://convox.com/"
  url "https://github.com/convox/convox/archive/3.10.3.tar.gz"
  sha256 "7cb8b370447b12fe36bb95ad18f6d5ae07b921fbe4dcedcc044cb26b724272ad"
  license "Apache-2.0"
  version_scheme 1

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4df3384b12bfc8c81880ed209aad13e39678dae5977cd978fa4bad2e32098ef1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5af396760d1791b632ec9ee963fef3d893bb23997abe1abe798458c930dd0da4"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b959578573a443b0562a93cde6d91f3ad4001a2293e99f6865607ad808b27476"
    sha256 cellar: :any_skip_relocation, ventura:        "963d28483cba67570397f6ede75bd0996371fd58322f1367011f30bf16b6a6d5"
    sha256 cellar: :any_skip_relocation, monterey:       "7d919e70b3e9421a7ea2a3a840ba9790bb7aba049a76c9d5c1172dc3ff3150f4"
    sha256 cellar: :any_skip_relocation, big_sur:        "95a803f4552a8f400453149da0d1c8490e40374d1736f6953941a8d299295c11"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bc08b10d69a03791d05cf1cca587fab2a4afd0659aec0a4ed7ea2d71f8a116ae"
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
