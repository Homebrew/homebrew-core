class Aqua < Formula
  desc "Declarative CLI Version manager"
  homepage "https://aquaproj.github.io/"
  url "https://github.com/aquaproj/aqua/archive/refs/tags/v2.64.0.tar.gz"
  sha256 "77e7628db9caf7b1adc49f6c21c3e6a55f45697b712e53403fe4f7114132f32e"
  license "MIT"
  head "https://github.com/aquaproj/aqua.git", branch: "main"

  # Upstream creates releases that use a stable tag (e.g., `v1.2.3`) but are
  # labeled as "pre-release" on GitHub before the version is released, so it's
  # necessary to use the `GithubLatest` strategy.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "4b0a040a7a39fa55fe3114b9d7cb9fa79e310dff45de07b8325f1aec8a388825"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "4b0a040a7a39fa55fe3114b9d7cb9fa79e310dff45de07b8325f1aec8a388825"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "4b0a040a7a39fa55fe3114b9d7cb9fa79e310dff45de07b8325f1aec8a388825"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "c78bc07a329f728c0c9a794ab376ce5906da1fe9054fa55b4850e97fc963131e"
    sha256 cellar: :any,                 x86_64_linux:      "f870ae753effa2bd2fb246a069a24783613990fa42c2aad36861055f75eeff52"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    system "go", "build", *std_go_args(ldflags: :goreleaser), "./cmd/aqua"

    generate_completions_from_executable(bin/"aqua", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/aqua --version")

    system bin/"aqua", "init"
    assert_match "depName=aquaproj/aqua-registry", (testpath/"aqua.yaml").read
  end
end
