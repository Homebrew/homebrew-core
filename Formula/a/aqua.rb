class Aqua < Formula
  desc "Declarative CLI Version manager"
  homepage "https://aquaproj.github.io/"
  url "https://github.com/aquaproj/aqua/archive/refs/tags/v2.66.1.tar.gz"
  sha256 "a906dcf62c7054e4c8694178a0ef890c95ab30a54e34f4476a3e74cd283d8cb9"
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
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "2ce844823fdfc28d14a557caf788fdf26892fb089c50f0f6681d7ccdf7804df2"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "2ce844823fdfc28d14a557caf788fdf26892fb089c50f0f6681d7ccdf7804df2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "2ce844823fdfc28d14a557caf788fdf26892fb089c50f0f6681d7ccdf7804df2"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "80fc7dfefe18336264ed2f682a11350a4b55d0e697a7220d013660ace9dbe2be"
    sha256 cellar: :any,                 x86_64_linux:      "906b626f321439261274b5721c4d8f8b538f65b639ea481cd56d5f6ddad1ba21"
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
