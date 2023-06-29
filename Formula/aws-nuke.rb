class AwsNuke < Formula
  desc "Nuke a whole AWS account and delete all its resources"
  homepage "https://github.com/rebuy-de/aws-nuke"
  url "https://github.com/rebuy-de/aws-nuke.git",
      tag:      "v2.23.0",
      revision: "58e46275b36028007cc3f50334aa74d6e3e7990a"
  license "MIT"
  head "https://github.com/rebuy-de/aws-nuke.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "401071cb0d6fdadd1addee241326417f872497a78bc6dbd4fc19aebb96af9b11"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "401071cb0d6fdadd1addee241326417f872497a78bc6dbd4fc19aebb96af9b11"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "401071cb0d6fdadd1addee241326417f872497a78bc6dbd4fc19aebb96af9b11"
    sha256 cellar: :any_skip_relocation, ventura:        "e33d8098f0b2bd7312f424f8e41bfc0fb3a3c013d5c862c10cfcd5863cf45517"
    sha256 cellar: :any_skip_relocation, monterey:       "e33d8098f0b2bd7312f424f8e41bfc0fb3a3c013d5c862c10cfcd5863cf45517"
    sha256 cellar: :any_skip_relocation, big_sur:        "e33d8098f0b2bd7312f424f8e41bfc0fb3a3c013d5c862c10cfcd5863cf45517"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "78fd3c6055033b273eece98c59cb6568819404d03d8a67359573b846222dbbc6"
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
