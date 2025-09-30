class Brev < Formula
  desc "CLI tool for managing workspaces provided by brev.dev"
  homepage "https://developer.nvidia.com/brev"
  url "https://github.com/brevdev/brev-cli/archive/refs/tags/v0.6.312.tar.gz"
  sha256 "265ef0698aa8d6b9fd7311b5aa16e2e0a2274dd4a2f3f01f1a035250825b8724"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "45874d14dadc6143bb0627536673aed5b7f219cfb7481d7344c703a1c07df79e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "be87f2ce1494f50d2f9ecac1f20920ef84b40ee920661fe5940f181160d7da6f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "be87f2ce1494f50d2f9ecac1f20920ef84b40ee920661fe5940f181160d7da6f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "be87f2ce1494f50d2f9ecac1f20920ef84b40ee920661fe5940f181160d7da6f"
    sha256 cellar: :any_skip_relocation, sonoma:        "a932f914bef72b4ef07d01b69e78301baa69f289b5314aa12cf3b3833e86e8b2"
    sha256 cellar: :any_skip_relocation, ventura:       "a932f914bef72b4ef07d01b69e78301baa69f289b5314aa12cf3b3833e86e8b2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6fb93d0a68df56c167438925321d0005a0b8ba67ef5684ffe9e5076431b8faa6"
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
