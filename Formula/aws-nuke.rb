class AwsNuke < Formula
  desc "Nuke a whole AWS account and delete all its resources"
  homepage "https://github.com/rebuy-de/aws-nuke"
  url "https://github.com/rebuy-de/aws-nuke.git",
      tag:      "v2.22.0",
      revision: "5e4600c17c0cb831923f033af28340b015d09a4b"
  license "MIT"
  head "https://github.com/rebuy-de/aws-nuke.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5b98f048a9aad0e6e46cd781c13ecb432edc0c7e9bf646291621d44b09e1249d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5b98f048a9aad0e6e46cd781c13ecb432edc0c7e9bf646291621d44b09e1249d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5b98f048a9aad0e6e46cd781c13ecb432edc0c7e9bf646291621d44b09e1249d"
    sha256 cellar: :any_skip_relocation, ventura:        "4ed9f983e9807357b4e20e16d68cd009834ba9d6dc0789df4e1efac331bce21c"
    sha256 cellar: :any_skip_relocation, monterey:       "4ed9f983e9807357b4e20e16d68cd009834ba9d6dc0789df4e1efac331bce21c"
    sha256 cellar: :any_skip_relocation, big_sur:        "4ed9f983e9807357b4e20e16d68cd009834ba9d6dc0789df4e1efac331bce21c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a8860204feec860d123f2d4c11ebe9f3cc929e2489140ada940ed25d78d99b1d"
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
