class Aqua < Formula
  desc "Declarative CLI Version manager"
  homepage "https://aquaproj.github.io/"
  url "https://github.com/aquaproj/aqua/archive/refs/tags/v2.57.1.tar.gz"
  sha256 "53c5f916ed702ff0e38fc31fe674a619550d8814ea46f38afeda457cb40594db"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9a09fb029fe1b5cf49efe0e6763b43d277ff0c515c481a4d44882ea746cd828a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9a09fb029fe1b5cf49efe0e6763b43d277ff0c515c481a4d44882ea746cd828a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9a09fb029fe1b5cf49efe0e6763b43d277ff0c515c481a4d44882ea746cd828a"
    sha256 cellar: :any_skip_relocation, sonoma:        "b68ff4b6b36ed9269eec5820c1e72a79ff665b9e99115702cb6a304ae80b8b9e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e03084e4605a07fe993b016a94910112b6e6221f6a48c4b1cf50cc791453ac95"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9abeb76733884a9dff1e37e82bbda04a98872516f818800a805fdc9ee11ca673"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version} -X main.commit=#{tap.user} -X main.date=#{time.iso8601}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/aqua"

    generate_completions_from_executable(bin/"aqua", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/aqua --version")

    system bin/"aqua", "init"
    assert_match "depName=aquaproj/aqua-registry", (testpath/"aqua.yaml").read
  end
end
