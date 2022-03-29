class Convox < Formula
  desc "Command-line interface for the Convox PaaS"
  homepage "https://convox.com/"
  url "https://github.com/convox/convox/archive/3.3.5.tar.gz"
  sha256 "c4b775642bb63434de78ea0864f00ea05351c8b9ce5046393286f8d4d3a430fd"
  license "Apache-2.0"
  version_scheme 1

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cd14d889dce933cfdd1cb22bb0b907db0c0e6423a6ac39cdc4a2a7ad2f08fa8b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "bf6abec0c97035ad67487ce537ed560b12bd8ebbd634c166fc69d228d533097d"
    sha256 cellar: :any_skip_relocation, monterey:       "5d9db8341bc67a0cf5f4a7bfc21bf0b7e34eb422a55ab3c87d96a5a83cb23f6e"
    sha256 cellar: :any_skip_relocation, big_sur:        "4abd103d5c92292e2dbaf2d23a8f7108f95da032c5c707c0d2785554c990b017"
    sha256 cellar: :any_skip_relocation, catalina:       "bc44aa5e35d25c79b220b2b5c4ea9f4fc237dd5dfb635a1cd5a2239c3fc664e8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8153d48bf1e37b166b6ecd3140d0518e5785c81f3ef3d88b0357ceec0c54dbf2"
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
