class Convox < Formula
  desc "Command-line interface for the Convox PaaS"
  homepage "https://convox.com/"
  url "https://github.com/convox/convox/archive/refs/tags/3.14.3.tar.gz"
  sha256 "dccc133ed178b4513fa7a7851e5fb8b3dc90247391737be781e3811df88aa1a6"
  license "Apache-2.0"
  version_scheme 1

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e3ec5e3b8d3fe309d92bd95b7c4f0df28a010e842844a6cafee66c1b40c3f94b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3ada7dc522c4cd3a9d092b31c245ac393a7baecc704de78682f0160aef2c082d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b8b2b78a2e337993cfcc528be7d34da9b790ae0f98efc17e9ecb3d2e227dc866"
    sha256 cellar: :any_skip_relocation, sonoma:         "dd71064bb7a2b69ba875e4fce27222e6cbe4bcb0a88cc4a160f5d67c50739c03"
    sha256 cellar: :any_skip_relocation, ventura:        "b6369e05393f524028ee88875eab38735b36917dd407ab889ca50edc9b32b8fd"
    sha256 cellar: :any_skip_relocation, monterey:       "3c69c3b375060528b6961dd9b0d51ec903b3e758e78357bb6f15f0bf6d9da9ed"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f0d07f32c892e93052f6c762b48371316bc70ef133dd6fc4556669c77741edaf"
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
