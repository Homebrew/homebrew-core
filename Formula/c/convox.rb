class Convox < Formula
  desc "Command-line interface for the Convox PaaS"
  homepage "https://convox.com/"
  url "https://github.com/convox/convox/archive/3.13.4.tar.gz"
  sha256 "22f9533b117ee8f084404e59354c4f19c75846f8ca53b2c23fd6a55d2f2dcb09"
  license "Apache-2.0"
  version_scheme 1

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f3e4fb644e1404b4bdc6f6051bbbeb728fec4705d146bccf6ccb34dc3e322d1a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f9e5075fdb54cfec852a0e77898ed19a39cb072060c87165538bbcbca3d2c9d1"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "67b96884e3d229703e145398dd4fc8c658556f95f8c2b18f5570c1b3e2ecd277"
    sha256 cellar: :any_skip_relocation, ventura:        "0b7a1bf8245fe5b89ea39677c34e90bffe279375611f8edf6a8f3202a015d80c"
    sha256 cellar: :any_skip_relocation, monterey:       "480d1a94abc8f1f80bea8fe7977eebd981ff625891cc8980d66bec577e40851f"
    sha256 cellar: :any_skip_relocation, big_sur:        "31025afa4584f66af826ed33c59f6f4bc3dc3417e1120a14df1e46cbd167cea6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e49f7d5e5d5d66781ea3b29b65b2255fa503ef16939faea1fc35bd8fafb85ab2"
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
