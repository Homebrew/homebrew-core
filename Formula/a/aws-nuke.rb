class AwsNuke < Formula
  desc "Nuke a whole AWS account and delete all its resources"
  homepage "https://github.com/ekristen/aws-nuke"
  url "https://github.com/ekristen/aws-nuke.git",
      tag:      "v3.22.0",
      revision: "d76d6ef250a93df89721201fbc17eca71ff4f5db"
  license "MIT"
  head "https://github.com/ekristen/aws-nuke.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "094c13b3ae605804052b90da606fd15ae683c0a4da5ab917bef22516be82a3e4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "094c13b3ae605804052b90da606fd15ae683c0a4da5ab917bef22516be82a3e4"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "094c13b3ae605804052b90da606fd15ae683c0a4da5ab917bef22516be82a3e4"
    sha256 cellar: :any_skip_relocation, sonoma:        "e90a67cbcf1afe970e0f2ec2d4a524b7ed75c0ab9a218aba1639191db5714439"
    sha256 cellar: :any_skip_relocation, ventura:       "e90a67cbcf1afe970e0f2ec2d4a524b7ed75c0ab9a218aba1639191db5714439"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "49f49fb9197f645127189c5b8d64bfc281aa069c7f3d367f7b24b7bf9945acd9"
  end

  depends_on "go" => :build

  def install
    build_xdst="github.com/ekristen/aws-nuke/v#{version.major}/cmd"
    ldflags = %W[
      -s -w
      -X #{build_xdst}.BuildVersion=#{version}
      -X #{build_xdst}.BuildDate=#{time.strftime("%F")}
      -X #{build_xdst}.BuildHash=#{Utils.git_head}
      -X #{build_xdst}.BuildEnvironment=#{tap.user}
    ]
    with_env(
      "CGO_ENABLED" => "0",
    ) do
      system "go", "build", *std_go_args(ldflags:)
    end

    pkgshare.install "config"

    generate_completions_from_executable(bin/"aws-nuke", "completion")
  end

  test do
    assert_match "InvalidClientTokenId", shell_output(
      "#{bin}/aws-nuke --config #{pkgshare}/config/example.yaml --access-key-id fake --secret-access-key fake 2>&1",
      255,
    )
    assert_match "IAMUser", shell_output("#{bin}/aws-nuke resource-types")
  end
end
