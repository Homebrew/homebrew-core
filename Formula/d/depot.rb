class Depot < Formula
  desc "Build your Docker images in the cloud"
  homepage "https://depot.dev/"
  url "https://github.com/depot/cli/archive/refs/tags/v2.101.41.tar.gz"
  sha256 "6117fe53f39646f39ec549d244a2d4ac2bf4e914658f359b54bc4e2dc2cf3a5d"
  license "MIT"
  head "https://github.com/depot/cli.git", branch: "main"

  # Upstream sometimes creates a tag with a stable version format but does not
  # create a release on GitHub.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "390733a9b0af77218d393346199c01652a9f9b9818b1f4c3531877d8b37a5b89"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "390733a9b0af77218d393346199c01652a9f9b9818b1f4c3531877d8b37a5b89"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "390733a9b0af77218d393346199c01652a9f9b9818b1f4c3531877d8b37a5b89"
    sha256 cellar: :any_skip_relocation, sonoma:        "3bd1eddd3b0c882ac65671f51ae1b4655b3dbe16c4c7ab03095c168f36529f40"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c512873e6ea5e50a70c0a8013fb40dbade58c942aa9fc51ecd0ea5771a07ac9a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9b4c9192d0117a4a73e21d9df21a02a646bb933b4fc0bd624e6ec8ded68469f2"
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
