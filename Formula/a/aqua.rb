class Aqua < Formula
  desc "Declarative CLI Version manager"
  homepage "https://aquaproj.github.io/"
  url "https://github.com/aquaproj/aqua/archive/refs/tags/v2.59.1.tar.gz"
  sha256 "d0fe2512b6250c151b8b387db97601c4110dfbf038dd36499b325e85b78a5c70"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "10ef7fca8e49c3326b0a4c2678c9f5987f53e2e9598b5d389cff9343ce540b1a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "10ef7fca8e49c3326b0a4c2678c9f5987f53e2e9598b5d389cff9343ce540b1a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "10ef7fca8e49c3326b0a4c2678c9f5987f53e2e9598b5d389cff9343ce540b1a"
    sha256 cellar: :any_skip_relocation, sonoma:        "d9500892f5f8f1bed1ce751c08233fcc968835f6710c5fe8708f71055b61f074"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5735e6e4becf0b5d790ce1b084ddfde7ed98ab63d2af633643628210f2a4224a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "36d2a1d84e082640e386ec9a44982c20f7923f7731b3be3025ab471a26a35fe4"
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
