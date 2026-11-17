class Berglas < Formula
  desc "Tool for managing secrets on Google Cloud"
  homepage "https://github.com/GoogleCloudPlatform/berglas"
  url "https://github.com/GoogleCloudPlatform/berglas/archive/refs/tags/v2.0.19.tar.gz"
  sha256 "2a44df65587814d80a776cd876b8127af2fa6dd6509bef71aff17bd9b1796340"
  license "Apache-2.0"
  head "https://github.com/GoogleCloudPlatform/berglas.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "a46b4a34404007fc23aa5cc076d92f15328b12a3cccad8cb30f2d8967d2cb33f"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "a46b4a34404007fc23aa5cc076d92f15328b12a3cccad8cb30f2d8967d2cb33f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "a46b4a34404007fc23aa5cc076d92f15328b12a3cccad8cb30f2d8967d2cb33f"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "85b5e90064a417fe16011f166fd8e5e5ff1ca846cfb4e7b9fdca73e32dd4fa00"
    sha256 cellar: :any,                 x86_64_linux:      "3cc85d7fc7a0dc38b76e8750bcf802e7a7cfaf5ad076d7cf3457baa3a8c40661"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = %W[
      -X github.com/GoogleCloudPlatform/berglas/v2/internal/version.name=berglas
      -X github.com/GoogleCloudPlatform/berglas/v2/internal/version.version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"berglas", "completion", shells: [:bash, :zsh])
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/berglas -v")

    out = shell_output("#{bin}/berglas list -l info homebrewtest 2>&1", 61)
    assert_match "could not find default credentials.", out
  end
end
