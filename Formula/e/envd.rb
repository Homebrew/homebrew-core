class Envd < Formula
  desc "Reproducible development environment for AI/ML"
  homepage "https://envd.tensorchord.ai"
  url "https://github.com/tensorchord/envd/archive/refs/tags/v1.3.2.tar.gz"
  sha256 "8dbf205f74c0f4a808141f9c20d24aab46d5cd60532c56311b37c44f171ee36e"
  license "Apache-2.0"
  head "https://github.com/tensorchord/envd.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c30b5d3e24326c0267013a4e782456d5c28b2c4e4f148a30f2c7a53442203867"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "470ee944209e43101311bb6dcac1229ccdd4cb79d5d2a01920a2d5c3c538c98c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b06ba64dff2c26d24551f9f214b72186f33dd243e2f8247b6770cc0316de1724"
    sha256 cellar: :any_skip_relocation, sonoma:        "2dd121d09bebf80d4c4c7ea5202c9b40ab4bf597e67eab0f4a3bf039d36a0431"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c52d0a1c68088514d73d5ce87e20a41044f55295751bd9adee50a9944489bfac"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cd6eaba53e13bc85634b3653a8b4ba96706ee882bf7c241af66724d53cf7a42b"
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
