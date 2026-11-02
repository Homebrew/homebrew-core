class Aqua < Formula
  desc "Declarative CLI Version manager"
  homepage "https://aquaproj.github.io/"
  url "https://github.com/aquaproj/aqua/archive/refs/tags/v2.66.0.tar.gz"
  sha256 "679aa3a1a610c8d6c21d5843a5a30179d60ad301e4c3fae9d1e7b05fd01df8f2"
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
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "021c1c907dc8d9196394d2e4bb0f8f3781263c0f98e1b4d9ff5e84f353944ed7"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "021c1c907dc8d9196394d2e4bb0f8f3781263c0f98e1b4d9ff5e84f353944ed7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "021c1c907dc8d9196394d2e4bb0f8f3781263c0f98e1b4d9ff5e84f353944ed7"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "df12892745528c91fbb2d54ccda660a9780bb406d77be62030d2d7ddb7587de8"
    sha256 cellar: :any,                 x86_64_linux:      "439a290026eb515fcc07bb6681686212dfa4f63c50358d7c153d384850f0edb0"
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
