class AwsNuke < Formula
  desc "Nuke a whole AWS account and delete all its resources"
  homepage "https://github.com/ekristen/aws-nuke"
  url "https://github.com/ekristen/aws-nuke.git",
      tag:      "v3.27.0",
      revision: "5d5a72014aa823ce2655ca925f8449f96c47acbf"
  license "MIT"
  head "https://github.com/ekristen/aws-nuke.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4e3d2ead63ec2338ad7eb5b7089fad5a88ef0b54264ed8cc3b2d0b21797da653"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4e3d2ead63ec2338ad7eb5b7089fad5a88ef0b54264ed8cc3b2d0b21797da653"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "4e3d2ead63ec2338ad7eb5b7089fad5a88ef0b54264ed8cc3b2d0b21797da653"
    sha256 cellar: :any_skip_relocation, sonoma:        "75acbe4b9bf94264800bcc5fc463ff751b5b474685d6b74cb9e40801e6db7534"
    sha256 cellar: :any_skip_relocation, ventura:       "75acbe4b9bf94264800bcc5fc463ff751b5b474685d6b74cb9e40801e6db7534"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2c93189e51af0d12e1d728c656bbf745d5b4f7057f13571465fc58eb8f5de839"
  end

  depends_on "go" => :build

  def install
    build_xdst="github.com/ekristen/aws-nuke/v#{version.major}/pkg/common"
    ldflags = %W[
      -s -w
      -X #{build_xdst}.SUMMARY=#{version}
    ]
    with_env(
      "CGO_ENABLED" => "0",
    ) do
      system "go", "build", *std_go_args(ldflags:)
    end

    pkgshare.install "pkg/config"

    generate_completions_from_executable(bin/"aws-nuke", "completion")
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
