class Aqua < Formula
  desc "Declarative CLI Version manager"
  homepage "https://aquaproj.github.io/"
  url "https://github.com/aquaproj/aqua/archive/refs/tags/v2.62.3.tar.gz"
  sha256 "fceb5a55a9e8dc7996ed8b6cafbb463997c82ba44e07c39ffc5f0b8fa3f67417"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8fb23fb94fa385f14e61ca47bab5538293dbe9ddd8d1d022edc2fe2946be46aa"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8fb23fb94fa385f14e61ca47bab5538293dbe9ddd8d1d022edc2fe2946be46aa"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8fb23fb94fa385f14e61ca47bab5538293dbe9ddd8d1d022edc2fe2946be46aa"
    sha256 cellar: :any_skip_relocation, sonoma:        "017efd0c98534cd260d5eb6b277e69722688017aa17fced63b3a6da5beab8c23"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6a800cb77b7a76c37d0d0b6e8c2151cb41e300ad906f00d2ccbf774c25e3b5e8"
    sha256 cellar: :any,                 x86_64_linux:  "3f37611acbe58ef2fc004b4dc4105610aa6c61c2257b86cf8ad2f1fb4cf1b433"
  end

  depends_on "go" => :build

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
