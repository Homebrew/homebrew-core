class KosliCli < Formula
  desc "CLI for managing Kosli"
  homepage "https://docs.kosli.com/client_reference/"
  url "https://github.com/kosli-dev/cli/archive/refs/tags/v2.7.8.tar.gz"
  sha256 "58a2b930aefa77d36171f7409d1b7f0dcf5e79e92aa0d427e36583892a13ff2c"
  license "MIT"
  head "https://github.com/kosli-dev/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "cad16573775ba00d779dc779c28e53231d4a26a8ab365782625782490718553c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "49c3bc3d7069c1500b6ed96718e8099da8377d144e3e988a72ff14345e6b978f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "18686f171c66f167d061b9d749db995b783a2338997ae0b5d0a5a18911eb2c6d"
    sha256 cellar: :any_skip_relocation, sonoma:         "980320954ab64ad282b394e1a06e66fdd5cc8e84c7ce737dfb4eb20e769e6113"
    sha256 cellar: :any_skip_relocation, ventura:        "569c9e6230fec838591b9801cf3869b92e5fc58f194133ab87e2ecf74bdaadbf"
    sha256 cellar: :any_skip_relocation, monterey:       "5b1b034225fcd3eaadcd454ea71d0bc78a7df23779b5a07a836900d1b5fc2d4d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3a19fab803a3f41adf795d5f0c8602e20c9d20a58f27a4093019347b8f48ae1f"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/kosli-dev/cli/internal/version.version=#{version}
      -X github.com/kosli-dev/cli/internal/version.gitCommit=#{tap.user}
      -X github.com/kosli-dev/cli/internal/version.gitTreeState=clean
    ]
    system "go", "build", *std_go_args(output: bin/"kosli", ldflags: ldflags), "./cmd/kosli"

    generate_completions_from_executable(bin/"kosli", "completion", base_name: "kosli")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/kosli version")

    assert_match "OK", shell_output("#{bin}/kosli status")
  end
end
