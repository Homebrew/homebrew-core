class Infracost < Formula
  desc "Cost estimates for Terraform"
  homepage "https://www.infracost.io/docs/"
  url "https://github.com/infracost/infracost/archive/v0.10.15.tar.gz"
  sha256 "566be4b7fc228d07a842c11797a5976d4699226ece752b0ff5f9867c2e0e4301"
  license "Apache-2.0"
  head "https://github.com/infracost/infracost.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ba2b6652286f1212a84b120584d6f16197c279b94e5a55544c635838df3acb2c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ba2b6652286f1212a84b120584d6f16197c279b94e5a55544c635838df3acb2c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8ae744e31e898d09d52a28b94aa1ef92e0b93ed65c2f224778dfff75c5fef9fe"
    sha256 cellar: :any_skip_relocation, ventura:        "17084c190f2568da1e8e7e0aa021444e57d7e833532bc453289c1790d1358b15"
    sha256 cellar: :any_skip_relocation, monterey:       "e6f6d1f2a0430318b1647b5944acbf61ebe1859252eb4ceca24062926879e887"
    sha256 cellar: :any_skip_relocation, big_sur:        "17084c190f2568da1e8e7e0aa021444e57d7e833532bc453289c1790d1358b15"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "634d735366081a57799cd12fb92292826d49ae9bfa239a30d0d302b8a6be3e37"
  end

  depends_on "go" => :build
  depends_on "terraform" => :test

  def install
    ENV["CGO_ENABLED"] = "0"
    ldflags = "-X github.com/infracost/infracost/internal/version.Version=v#{version}"
    system "go", "build", *std_go_args(ldflags: ldflags), "./cmd/infracost"

    generate_completions_from_executable(bin/"infracost", "completion", "--shell")
  end

  test do
    assert_match "v#{version}", shell_output("#{bin}/infracost --version 2>&1")

    output = shell_output("#{bin}/infracost breakdown --no-color 2>&1", 1)
    assert_match "No INFRACOST_API_KEY environment variable is set.", output
  end
end
