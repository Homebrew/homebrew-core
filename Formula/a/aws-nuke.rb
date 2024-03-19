class AwsNuke < Formula
  desc "Nuke a whole AWS account and delete all its resources"
  homepage "https://github.com/rebuy-de/aws-nuke"
  url "https://github.com/rebuy-de/aws-nuke.git",
      tag:      "v2.25.0",
      revision: "2bd22d5e5c0cf6a4011b3c08a5b1c25e2e6c75bd"
  license "MIT"
  head "https://github.com/rebuy-de/aws-nuke.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c3286cec74fcdd7867c2ab1a0594b80107c75f049b04c833977814fe3e407930"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "12c5e77d73638f6bfee30759160f559aed88ab964c0af28732c76a5bcab5bdb4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "12c5e77d73638f6bfee30759160f559aed88ab964c0af28732c76a5bcab5bdb4"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "12c5e77d73638f6bfee30759160f559aed88ab964c0af28732c76a5bcab5bdb4"
    sha256 cellar: :any_skip_relocation, sonoma:         "f10b53d737493b2b2e4a31b34b450fa601369cb68643ea2e99b534f4e5168a0c"
    sha256 cellar: :any_skip_relocation, ventura:        "9bfc6b886796a4059e9440a28375985a7eb5d5ed336098c6065f0d10bb3ef7e5"
    sha256 cellar: :any_skip_relocation, monterey:       "9bfc6b886796a4059e9440a28375985a7eb5d5ed336098c6065f0d10bb3ef7e5"
    sha256 cellar: :any_skip_relocation, big_sur:        "9bfc6b886796a4059e9440a28375985a7eb5d5ed336098c6065f0d10bb3ef7e5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c22ad093adadf1577b33212b71a82f23d0e1ae9c5e81e792186caa3c63125e2a"
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
