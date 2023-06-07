class AwsNuke < Formula
  desc "Nuke a whole AWS account and delete all its resources"
  homepage "https://github.com/rebuy-de/aws-nuke"
  url "https://github.com/rebuy-de/aws-nuke.git",
      tag:      "v2.22.1",
      revision: "7232d0055220d26efa410bae9294a2ab71d984e1"
  license "MIT"
  head "https://github.com/rebuy-de/aws-nuke.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4414d562c8f4e9cf942d6d4ebc8ba2c656bbe6f499aa3df64fc2acb02b4d3b48"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4414d562c8f4e9cf942d6d4ebc8ba2c656bbe6f499aa3df64fc2acb02b4d3b48"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4414d562c8f4e9cf942d6d4ebc8ba2c656bbe6f499aa3df64fc2acb02b4d3b48"
    sha256 cellar: :any_skip_relocation, ventura:        "9a6d090e634267d9e7eb9c94b8db86d0eaf35167e2691d75a4a04474fdd4c2a7"
    sha256 cellar: :any_skip_relocation, monterey:       "9a6d090e634267d9e7eb9c94b8db86d0eaf35167e2691d75a4a04474fdd4c2a7"
    sha256 cellar: :any_skip_relocation, big_sur:        "9a6d090e634267d9e7eb9c94b8db86d0eaf35167e2691d75a4a04474fdd4c2a7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "13d5ff1c665b6554c1d8f23261e6582d5fdfae48f6164a436cbf37874f4ee03a"
  end

  depends_on "go" => :build

  def install
    build_xdst="github.com/rebuy-de/aws-nuke/v#{version.major}/cmd"
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
      system "go", "build", *std_go_args(ldflags: ldflags)
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
