class Aqua < Formula
  desc "Declarative CLI Version manager"
  homepage "https://aquaproj.github.io/"
  url "https://github.com/aquaproj/aqua/archive/refs/tags/v2.58.1.tar.gz"
  sha256 "b1d50c44075b621fe64159bd9d573e9bc0712639c633c4037909dab6efc25fe2"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d0cd3dede61a21b16532cdc400740a5c0691f5ac084b95005f03652c38ce6165"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d0cd3dede61a21b16532cdc400740a5c0691f5ac084b95005f03652c38ce6165"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d0cd3dede61a21b16532cdc400740a5c0691f5ac084b95005f03652c38ce6165"
    sha256 cellar: :any_skip_relocation, sonoma:        "1d74132bccfaa3af8987f9a1d9190a576a40c9d826235be07c26f326b9a62b1b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8a0660097df567fb10819740f34c5800d4b7bfac34ec8edbd5b66da569b953f8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0d53ab963f58342f56eba7229cb68788035147f41cbce74c4409aed130dd7801"
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
