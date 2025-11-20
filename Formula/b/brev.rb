class Brev < Formula
  desc "CLI tool for managing workspaces provided by brev.dev"
  homepage "https://developer.nvidia.com/brev"
  url "https://github.com/brevdev/brev-cli/archive/refs/tags/v0.6.314.tar.gz"
  sha256 "8aace14f489e40db1fb63069e59b6d6c9613d8a2ac84342a346db04a127da8d4"
  license "MIT"
  head "https://github.com/brevdev/brev-cli.git", branch: "main"

  # Upstream appears to use GitHub releases to indicate that a version is
  # released (and some tagged versions don't end up as a release), so it's
  # necessary to check release versions instead of tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "bf6e04bc9b6014cdd639e5737f2f97109d16f4c035393a38b76165d35b6eb6cf"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bf6e04bc9b6014cdd639e5737f2f97109d16f4c035393a38b76165d35b6eb6cf"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bf6e04bc9b6014cdd639e5737f2f97109d16f4c035393a38b76165d35b6eb6cf"
    sha256 cellar: :any_skip_relocation, sonoma:        "f24f9c60f50288e46e10b8a8a30f9efcf2c4adfa51503889bb0ac7c902e8276e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "955d4d2288fd7b955eafdd9644c31bbfdf2bff066977aede8d01750ec362f329"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c38cdda4fae73cfa38c071ee8547148ebc0446ee55afa095c424f16d4b9cdab6"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/brevdev/brev-cli/pkg/cmd/version.Version=v#{version}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"brev", "completion")
  end

  test do
    system bin/"brev", "healthcheck"
  end
end
