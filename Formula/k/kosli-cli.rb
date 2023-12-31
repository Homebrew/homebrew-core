class KosliCli < Formula
  desc "CLI for managing Kosli"
  homepage "https://docs.kosli.com/client_reference/"
  url "https://github.com/kosli-dev/cli/archive/refs/tags/v2.6.18.tar.gz"
  sha256 "b076cff7b4c74905a817d112021b35b03a80b7ea4de430c8dec86022165beebc"
  license "MIT"
  head "https://github.com/kosli-dev/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "198a55f0f5b67f429aa8e7234bd204edf846fb3fe57517e4250e86aac8c8edaa"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9f772ef1d30f71567132a934d934f963ed6aea03060a949b93c76c545aaac291"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "521bebf9c22b3e3f6d3b52f309a7cf119486e7dcc3e2be58916884b7eeed4b35"
    sha256 cellar: :any_skip_relocation, sonoma:         "2a522915f0dee48cbceac4b475b21c9b942c78bf1e89159bebdc23e2cdfe1687"
    sha256 cellar: :any_skip_relocation, ventura:        "53c59ba102016a548713303bafd0e3da9d21ba50a5d23bb81dfe3cbaccf8045f"
    sha256 cellar: :any_skip_relocation, monterey:       "b3029f13bc52134d834fe560f50ca70b0d037429c78526299e128ff30a709c2b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5a195b0e37c84e53d68df41daf3512a737323b327e557a172412ce8822d12e70"
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
