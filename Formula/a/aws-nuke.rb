class AwsNuke < Formula
  desc "Nuke a whole AWS account and delete all its resources"
  homepage "https://aws-nuke.ekristen.dev"
  url "https://github.com/ekristen/aws-nuke/archive/refs/tags/v3.69.1.tar.gz"
  sha256 "6b616a95c6e0fd9335e59b618c89501e900a42c1210f9f0b080b90ce1cbbfc1d"
  license "MIT"
  head "https://github.com/ekristen/aws-nuke.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "923dc2bec65ef0e2b026293f36cee27ca5135ce6b43cdaf4c31d81d565231743"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "923dc2bec65ef0e2b026293f36cee27ca5135ce6b43cdaf4c31d81d565231743"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "923dc2bec65ef0e2b026293f36cee27ca5135ce6b43cdaf4c31d81d565231743"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "a6f45343b130e616e3753a8fa59247b77e0f0910a92da99e6de3211c2b93726f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "5c643acf251c6e154327a802b489a23e0bab587a8d310e0d9c544a80bade1d8d"
  end

  depends_on "go" => :build

  allow_network_access! :test

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = %W[-X github.com/ekristen/aws-nuke/v#{version.major}/pkg/common.SUMMARY=#{version}]
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
