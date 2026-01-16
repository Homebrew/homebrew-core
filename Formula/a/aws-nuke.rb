class AwsNuke < Formula
  desc "Nuke a whole AWS account and delete all its resources"
  homepage "https://github.com/ekristen/aws-nuke"
  url "https://github.com/ekristen/aws-nuke/archive/refs/tags/v3.63.1.tar.gz"
  sha256 "6bd5bbb895e78782bc0cae46f93b81fe6e308583048b84dbb6991af6a3e06343"
  license "MIT"
  head "https://github.com/ekristen/aws-nuke.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3403def46ffdf6eac69674baacff179a0601a1f6bd4ee94146d9237169540907"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3403def46ffdf6eac69674baacff179a0601a1f6bd4ee94146d9237169540907"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3403def46ffdf6eac69674baacff179a0601a1f6bd4ee94146d9237169540907"
    sha256 cellar: :any_skip_relocation, sonoma:        "f69075023ba458313789a886f6dd649ca156b0c2574e2214a1fee847464f201f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "75699e74bd771c5f538244ffa45778c96c11842349ad1b2de9768a9ee1881e7f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7d1a425356ea2b8b672ae7ce2279bea2db7348ba0553434ec187bc0755d629c9"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/ekristen/aws-nuke/v#{version.major}/pkg/common.SUMMARY=#{version}
    ]
    ENV["CGO_ENABLED"] = "0"
    system "go", "build", *std_go_args(ldflags:)

    pkgshare.install "pkg/config"

    generate_completions_from_executable(bin/"aws-nuke", shell_parameter_format: :cobra)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/aws-nuke --version")
    assert_match "InvalidClientTokenId", shell_output(
      "#{bin}/aws-nuke run --config #{pkgshare}/config/testdata/example.yaml \
      --access-key-id fake --secret-access-key fake 2>&1",
      1,
    )
    assert_match "IAMUser", shell_output("#{bin}/aws-nuke resource-types")
  end
end
