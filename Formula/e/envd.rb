class Envd < Formula
  desc "Reproducible development environment for AI/ML"
  homepage "https://envd.tensorchord.ai"
  url "https://github.com/tensorchord/envd/archive/refs/tags/v1.3.3.tar.gz"
  sha256 "9e196849812db7c6c595beb802d634f34a2ae257e01229340ff5d97560206b5d"
  license "Apache-2.0"
  head "https://github.com/tensorchord/envd.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fc68905745e52ef132d265500363b7a4239f8cd288946249939193fc6cadd5e7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "aaaadd48d15929ac92b9ada1f83b8fd729ed25a942cd17845e79f2cbd720ab99"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "103789ee3be36b997a2b804f3e23a34912cb8526729201a7216996682721605d"
    sha256 cellar: :any_skip_relocation, sonoma:        "5194cc15667fbab79622043d401d583344956b0133d4d82689980fe7f5a6f218"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3d6781b5c9f848b62937169d2ce77246b75ca3bb35524332cff19f31af390b2e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "277ec1330bfaa444052bb214e1b4d08a28f7b8a881b10a4e531f494511b07406"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
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
    expected = /failed to list containers: (Cannot|permission denied while trying to) connect to the Docker daemon/
    assert_match expected, shell_output("#{bin}/envd env list 2>&1", 1)
  end
end
