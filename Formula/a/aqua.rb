class Aqua < Formula
  desc "Declarative CLI Version manager"
  homepage "https://aquaproj.github.io/"
  url "https://github.com/aquaproj/aqua/archive/refs/tags/v2.57.2.tar.gz"
  sha256 "d0e06f2a2aba07b2779dfc32dca6c6a01839322927ddd3770667b4169b0138e7"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2ab3ffff6e7aaa02e6e066bae96935524c87978e936ef21c2270aa625d28cba7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2ab3ffff6e7aaa02e6e066bae96935524c87978e936ef21c2270aa625d28cba7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2ab3ffff6e7aaa02e6e066bae96935524c87978e936ef21c2270aa625d28cba7"
    sha256 cellar: :any_skip_relocation, sonoma:        "4150b12243629c41157d2933c14f3d58d067e128ac5cf9cfc426e10839d60c90"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5eec26a48ac96a78286407186f66e8d23b8ea3c22de0a71dccbfcb02e4a0938c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4c619a4f0342ea510e716bac585887cb25bfea5f0d6a4c7b1826cfa5d21baa87"
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
