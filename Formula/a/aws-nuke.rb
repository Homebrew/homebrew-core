class AwsNuke < Formula
  desc "Nuke a whole AWS account and delete all its resources"
  homepage "https://aws-nuke.ekristen.dev"
  url "https://github.com/ekristen/aws-nuke/archive/refs/tags/v3.66.0.tar.gz"
  sha256 "3071dd7f1d61f42ca065af87aa675ada8ec11abfac08d135058845635561b676"
  license "MIT"
  head "https://github.com/ekristen/aws-nuke.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a05c51093ba31d391e04f69ed96fc3b175ca9ab7d45553163210eab690557220"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a05c51093ba31d391e04f69ed96fc3b175ca9ab7d45553163210eab690557220"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a05c51093ba31d391e04f69ed96fc3b175ca9ab7d45553163210eab690557220"
    sha256 cellar: :any_skip_relocation, sonoma:        "4908aadfb4c254ee73c0528fb4eebfc39f459ab74a8e5972a2e39bd3f67c8e54"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "efd4440bb488e3264c3fb9cc4de20883c6c68e4cc9037317f71c8385806b5527"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "12792b48374a2e91a6f3d42463fdeb450a080224040930371ef93e6b57609d68"
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
