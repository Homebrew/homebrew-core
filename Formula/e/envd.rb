class Envd < Formula
  desc "Reproducible development environment for AI/ML"
  homepage "https://envd.tensorchord.ai"
  url "https://github.com/tensorchord/envd/archive/refs/tags/v1.3.6.tar.gz"
  sha256 "795776d46263d2a21312cd3b4eabc6d3cc19560f82b02aee1dd066045eb7b5d2"
  license "Apache-2.0"
  head "https://github.com/tensorchord/envd.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "475246091bd23ee4fefdb4623e2924d432cc105cae293694261b127c68a028ad"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "9207f00ac858dc1b32189a9431d92b9332e6519b947b28e4e156cea3ecb96784"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "f252d5241288c65059ba83f144f11ed3c0bdb1b1a5e7c67d87d9336246330f98"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "b7dad3fdfa2bbab49a49f4d8365baa1aaa7e1791b451a7a0a0f5feb169b45c43"
    sha256 cellar: :any,                 x86_64_linux:      "4d4395bd94b500b1da06056a2824c2887931147be360f30daa8429ade6efc519"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = %W[
      -X github.com/tensorchord/envd/pkg/version.buildDate=#{time.iso8601}
      -X github.com/tensorchord/envd/pkg/version.version=#{version}
      -X github.com/tensorchord/envd/pkg/version.gitTag=v#{version}
      -X github.com/tensorchord/envd/pkg/version.gitCommit=#{tap.user}
      -X github.com/tensorchord/envd/pkg/version.gitTreeState=clean
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/envd"
    generate_completions_from_executable(bin/"envd", "completion", "--no-install", "--shell")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/envd version --short")

    ENV["DOCKER_HOST"] = "unix://#{testpath}/invalid.sock"
    expected = "failed to list containers: failed to connect to the docker API"
    assert_match expected, shell_output("#{bin}/envd env list 2>&1", 1)
  end
end
