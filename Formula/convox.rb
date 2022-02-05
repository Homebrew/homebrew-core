class Convox < Formula
  desc "Command-line interface for the Convox PaaS"
  homepage "https://convox.com/"
  url "https://github.com/convox/convox/archive/3.3.2.tar.gz"
  sha256 "3466f069686ce15d4b82cb533521b64a8db2f9dd1f155f72b14010e8e159e656"
  license "Apache-2.0"
  version_scheme 1

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "496dcef3b825678fbb35198d80547a79325165b6c031ad5aa0e06f1b2a1369b2"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "53030d90e145cb50b266cbf570c3a7d22e3775ccf7ad682e388328bbcdce74b7"
    sha256 cellar: :any_skip_relocation, monterey:       "d35b94a80905b13ae40cad8b0a26035b5f6c521eddb348237315622a74d02c3a"
    sha256 cellar: :any_skip_relocation, big_sur:        "fcf5f5ef94b20eae90ff57eeb0fed2aa037e88962be9d352120c846b4f3730f6"
    sha256 cellar: :any_skip_relocation, catalina:       "2c96b27e474fc9bd3c4b4841a0594c12f55193ae7bbb2e024d2ad4d420884ab5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "37d6df7a9a909b10dd64367c288e87bced94ea24961c3c130c058e9b152a9e4e"
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
