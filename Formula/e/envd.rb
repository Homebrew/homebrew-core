class Envd < Formula
  desc "Reproducible development environment for AI/ML"
  homepage "https://envd.tensorchord.ai"
  url "https://github.com/tensorchord/envd/archive/refs/tags/v1.3.4.tar.gz"
  sha256 "03a30eea6a13b2f7b05f5567b53a7288ef8ce8feeba454306dd3812f25f5019f"
  license "Apache-2.0"
  head "https://github.com/tensorchord/envd.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0bd17b4161896988fb657c4aac8cbfbd22c6a433f247c990e37f9cbb91c15f1f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "97d9a1637a5a10278e57b542145916ea6beb3c1368276a956e11413e9266e412"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "62d41efe36e7d6a169b930033a29cc1851a8520f996f41c04a2d12a8cb322df5"
    sha256 cellar: :any_skip_relocation, sonoma:        "89257f0e9a759ceed909a4558fa51a5b0986402864c47c0b056cb332f26b004e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ba5bb665dd0d932c6e64a51360a738eb585461d1860f5538b8245f58af2dbc6f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4bbb273c523824f838223846ae143eddfbdba5ca5cbc4d08c4eb0af37fb5afc1"
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
