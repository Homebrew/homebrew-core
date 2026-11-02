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
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "5b08b2a040c2723673df2b1305004f3ffdf53b430670852f9e77878e176007b4"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "5b08b2a040c2723673df2b1305004f3ffdf53b430670852f9e77878e176007b4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "5b08b2a040c2723673df2b1305004f3ffdf53b430670852f9e77878e176007b4"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "17838fb81cb9395cf79ea47b41a4584dad72fc474c8cc6ab9fce5c6d9114b3a6"
    sha256 cellar: :any,                 x86_64_linux:      "c2da88db1a9b5b384fc66a93142195088d90f1a620b0d1b72e828b77bdd98f8c"
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
