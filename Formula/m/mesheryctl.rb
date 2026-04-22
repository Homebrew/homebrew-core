class Mesheryctl < Formula
  desc "Command-line utility for Meshery, the cloud native management plane"
  homepage "https://meshery.io"
  url "https://github.com/meshery/meshery.git",
      tag:      "v1.0.11",
      revision: "a6cd637139f2b89dc4371e1b44ffe0df565bf6bd"
  license "Apache-2.0"
  head "https://github.com/meshery/meshery.git", branch: "master"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "17bd665758328dc5de6b54f1539329ad500743af7a2ee5eb26f6ec75083cfe62"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3ddf49112da8474d8faf65b8ce234cd6939527265575e8b8e9114b359095982a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "59c5f21dd259217c2b7542b0d8fc2896891c7be27c485c11aee9ec92adbfda9d"
    sha256 cellar: :any_skip_relocation, sonoma:        "148726aa074bb797566d74030ffe899fb45d3bbc0f6c9b089d0fe2bff3a652a2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a566ca02e18becf3ae8c63595a0d268104dc21207e2fc9b4ce2b3f9b2bff24ff"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5e891f4691bb845c1c1637d35fede779d75f064c613965e0cc0c20cb92c8abb2"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "0" if OS.linux?

    ldflags = %W[
      -s -w
      -X github.com/meshery/meshery/mesheryctl/internal/cli/root/constants.version=v#{version}
      -X github.com/meshery/meshery/mesheryctl/internal/cli/root/constants.commitsha=#{Utils.git_short_head}
      -X github.com/meshery/meshery/mesheryctl/internal/cli/root/constants.releasechannel=stable
    ]

    system "go", "build", *std_go_args(ldflags:), "./mesheryctl/cmd/mesheryctl"

    generate_completions_from_executable(bin/"mesheryctl", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mesheryctl version 2>&1")
    assert_match "Channel: stable", shell_output("#{bin}/mesheryctl system channel view 2>&1")

    # Test kubernetes error on trying to start meshery
    assert_match "The Kubernetes cluster is not accessible.", shell_output("#{bin}/mesheryctl system start 2>&1", 1)
  end
end
