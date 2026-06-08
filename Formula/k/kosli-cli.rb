class KosliCli < Formula
  desc "CLI for managing Kosli"
  homepage "https://docs.kosli.com"
  url "https://github.com/kosli-dev/cli/archive/refs/tags/v2.24.2.tar.gz"
  sha256 "593f8d9fa714df4839f56b4443ea6d416ef237fa71ef472c7ca24e3447df5bb3"
  license "MIT"
  head "https://github.com/kosli-dev/cli.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "bba020b4d7c85fa34335694db7802bfe1f5ae765793478b079f1b770e48d509f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4332058400ec31e02b14699793e5aba92c97bdc85e09351ad6a130849c739c62"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "365c3561725ba12c6b480f23e65e3ee6f1c49d5cdd8fafbbda7117a73a733bdc"
    sha256 cellar: :any_skip_relocation, sonoma:        "942fa74487288b4eb9538e1791341ca5de1ffffd2be97536a55f08c706f9843b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "fb3c11c1e8b09cb6f673348577ebbca927dbd1ca572d0dd936ee0378568dea62"
    sha256 cellar: :any,                 x86_64_linux:  "0e834bba8d310371396454990427f5b9e72f35c0cb77681d95aec7486a42df7b"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/kosli-dev/cli/internal/version.version=#{version}
      -X github.com/kosli-dev/cli/internal/version.gitCommit=#{tap.user}
      -X github.com/kosli-dev/cli/internal/version.gitTreeState=clean
    ]
    system "go", "build", *std_go_args(output: bin/"kosli", ldflags:), "./cmd/kosli"

    generate_completions_from_executable(bin/"kosli", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/kosli version")

    assert_match "OK", shell_output("#{bin}/kosli status")
  end
end
