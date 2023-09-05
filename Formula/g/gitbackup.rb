class Gitbackup < Formula
  desc "Tool to backup your Bitbucket, GitHub and GitLab repositories"
  homepage "https://github.com/amitsaha/gitbackup"
  url "https://github.com/amitsaha/gitbackup/archive/v0.9.0.tar.gz"
  sha256 "dc25680b498995ea4c52b1cb2c756aee200f163fc7dbfa695f0d0fd4cc10c28c"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e2662dc58792c8acff07d745e88026a58ad2916aa943f03e214861ffff83ced8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e2662dc58792c8acff07d745e88026a58ad2916aa943f03e214861ffff83ced8"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e2662dc58792c8acff07d745e88026a58ad2916aa943f03e214861ffff83ced8"
    sha256 cellar: :any_skip_relocation, ventura:        "9c458fa964243f8611a16564f9afc526a101cc2c1167a0f1dd85def0cd35ce20"
    sha256 cellar: :any_skip_relocation, monterey:       "9c458fa964243f8611a16564f9afc526a101cc2c1167a0f1dd85def0cd35ce20"
    sha256 cellar: :any_skip_relocation, big_sur:        "9c458fa964243f8611a16564f9afc526a101cc2c1167a0f1dd85def0cd35ce20"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2a062c0da560c0779e9ee952408cc4131980d0658f594933525ee795dd2e9635"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "0"
    system "go", "build", *std_go_args
  end

  test do
    assert_match "Please specify the git service type", shell_output("#{bin}/gitbackup 2>&1", 1)
  end
end
