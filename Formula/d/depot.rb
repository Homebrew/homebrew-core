class Depot < Formula
  desc "Build your Docker images in the cloud"
  homepage "https://depot.dev/"
  url "https://github.com/depot/cli/archive/refs/tags/v2.101.62.tar.gz"
  sha256 "acb795125de5238a81804fe31f5404b2f8061704722855c163dbb198f3f7882d"
  license "MIT"
  head "https://github.com/depot/cli.git", branch: "main"

  # Upstream sometimes creates a tag with a stable version format but does not
  # create a release on GitHub.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f5431a4a2dccebb03a329a7c1a98df7cf7f142ebdacd1c3a81d7615755e40fe3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f5431a4a2dccebb03a329a7c1a98df7cf7f142ebdacd1c3a81d7615755e40fe3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f5431a4a2dccebb03a329a7c1a98df7cf7f142ebdacd1c3a81d7615755e40fe3"
    sha256 cellar: :any_skip_relocation, sonoma:        "8cce26071e5125a54ec315f78dbcbb2a6fb28295ae80b15dd565745115ac0312"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ce5419873193e3451493bfc5718d714e1569c7f9a7f1e27d6736d13e0e5cfa3c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8be6df64711632596e7ed7f7442b29b97ab9929becb893c37af0a9a055e35687"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/depot/cli/internal/build.Version=#{version}
      -X github.com/depot/cli/internal/build.Date=#{time.iso8601}
      -X github.com/depot/cli/internal/build.SentryEnvironment=release
    ]

    system "go", "build", *std_go_args(ldflags:), "./cmd/depot"

    generate_completions_from_executable(bin/"depot", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/depot --version")
    output = shell_output("#{bin}/depot list builds 2>&1", 1)
    assert_match "Error: unknown project ID", output
  end
end
