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
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a28085fb70caf09c848d3606702946ac5330e6712ebb8d14f277188c849eb9db"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "30555cd1acd3d5c60f24800cb7299605593cc5d10b18fa220b54418d991f4abc"
    sha256 cellar: :any_skip_relocation, monterey:       "d7516fcd94989998cb3ad9c94557a342892f1506232925b29645239b55504e1d"
    sha256 cellar: :any_skip_relocation, big_sur:        "c4074da0faa1e339f2ef2a548ebaa1382ff4c61f8412ea37c357f05111c9fe48"
    sha256 cellar: :any_skip_relocation, catalina:       "8af7ce5f661e1c11aed584561b7cfb06c2ff9d2eb7a8b31e018a51eb74d0cfc3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dd5a9ad52d7449e34452155f263f0e038f767e20d817614ef81ddb9cfa4ce4f6"
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
