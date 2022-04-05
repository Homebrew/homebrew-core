class Convox < Formula
  desc "Command-line interface for the Convox PaaS"
  homepage "https://convox.com/"
  url "https://github.com/convox/convox/archive/3.4.2.tar.gz"
  sha256 "6381b4f4c6029771e268176d9278c6d4fb6a6f7abd28f9c89ffa498a0440f3e5"
  license "Apache-2.0"
  version_scheme 1

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cd6580ee3c04c966e5ead621cd50544cc7111ca9a46ac1dfc01b77f5f33a63b7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c2b1032780d72ff124cd6c3705d88b9f35e8ba094521c2d07ee38843971086ad"
    sha256 cellar: :any_skip_relocation, monterey:       "753a8b293653a5cec5cc3427e05d01079347da4ae23e55b69f716a5e61c74dac"
    sha256 cellar: :any_skip_relocation, big_sur:        "6f1038c6b5e6434c7129311ef971c2e3a13599bc95382f7dd74e18d0fc7e580a"
    sha256 cellar: :any_skip_relocation, catalina:       "ce921dd5003479271246559c4425cbcbda21d28020cfe8a4df4f53f34b36ee3a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8776e789b1c1dc49ee41f70b94bb09c32e7fabb37f03f367f9174b62d6479a72"
  end

  depends_on "go" => :build

  # Support go 1.17, remove when upstream patch is merged/released
  # https://github.com/convox/convox/pull/389
  patch do
    url "https://github.com/convox/convox/commit/d28b01c5797cc8697820c890e469eb715b1d2e2e.patch?full_index=1"
    sha256 "a0f94053a5549bf676c13cea877a33b3680b6116d54918d1fcfb7f3d2941f58b"
  end

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
