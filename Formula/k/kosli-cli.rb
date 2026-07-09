class KosliCli < Formula
  desc "CLI for managing Kosli"
  homepage "https://docs.kosli.com"
  url "https://github.com/kosli-dev/cli/archive/refs/tags/v2.32.0.tar.gz"
  sha256 "1308a8d6bfa9b64221e42ebbf65f4f26ded407ed30f711f1708a4ec72ac6642d"
  license "MIT"
  head "https://github.com/kosli-dev/cli.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0d93e05dfe8c0f3b7552116d2d152ab6fbe21cf2ee2da7fbfd7ec25b9bccb5bb"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4575021a664ddb678ff0f76d457d6b21728dd65d1769f96ac8d15580eaa9056b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fd9dcb508c2aa56e8755635e9ede13bc2e26ca96aafa9f3ab33e1f96e115008f"
    sha256 cellar: :any_skip_relocation, sonoma:        "fcc4d3653dff2f5ad7b60d96d102fd051cf53e5fdc21b7507a0ae03b45b15e90"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0627e5b9b1e6076cefcdd6260dd032a825e3aa5a13967f9e31630606abd956b6"
    sha256 cellar: :any,                 x86_64_linux:  "bfde556a965d8e98825fcf682eaba2ede7c64e5d9d34b93509a5615de1a9de74"
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
