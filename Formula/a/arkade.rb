class Arkade < Formula
  desc "Open Source Kubernetes Marketplace"
  homepage "https://blog.alexellis.io/kubernetes-marketplace-two-year-update/"
  url "https://github.com/alexellis/arkade/archive/refs/tags/0.11.124.tar.gz"
  sha256 "b9ea6634c53ff918093840386fd9bd43a8ae9b03228d06d55b0b24fad6188bd4"
  license "MIT"
  head "https://github.com/alexellis/arkade.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "debaad7785edce141e1e4b7a79a56b6332d3456b0f0eecc03e0da60a33dcae12"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "debaad7785edce141e1e4b7a79a56b6332d3456b0f0eecc03e0da60a33dcae12"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "debaad7785edce141e1e4b7a79a56b6332d3456b0f0eecc03e0da60a33dcae12"
    sha256 cellar: :any_skip_relocation, sonoma:        "095d12d8b97e7e90cc42d9f007f7301c50c6dcc8262d2069b86fc97eebe98c4a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "034ce7cb826de07587ff988a51a16a793100bd45cd2a73d39cbc318a141cbcb0"
    sha256 cellar: :any,                 x86_64_linux:  "f8fef2e6708af79e0aedde50446eeeecf4a817033e341a17fba92d96e4250b48"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -X github.com/alexellis/arkade/pkg.Version=#{version}
      -X github.com/alexellis/arkade/pkg.GitCommit=#{tap.user}
    ]
    system "go", "build", *std_go_args(ldflags:)

    bin.install_symlink "arkade" => "ark"

    generate_completions_from_executable(bin/"arkade", shell_parameter_format: :cobra)
    # make zsh completion also work for `ark` symlink
    inreplace zsh_completion/"_arkade", "#compdef arkade", "#compdef arkade ark=arkade"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/arkade version")
    assert_match "Info for app: openfaas", shell_output("#{bin}/arkade info openfaas")
  end
end
