class Gitbackup < Formula
  desc "Tool to backup your Bitbucket, GitHub and GitLab repositories"
  homepage "https://github.com/amitsaha/gitbackup"
  url "https://github.com/amitsaha/gitbackup/archive/refs/tags/v0.9.0.tar.gz"
  sha256 "dc25680b498995ea4c52b1cb2c756aee200f163fc7dbfa695f0d0fd4cc10c28c"
  license "MIT"
  head "https://github.com/amitsaha/gitbackup.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "540ead02d32ffc9b5ac96639dffe626f10224ebfdabfa524ea50c58e0d59aa2b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "5dfd46e58a735957a243ca725303b5747345e3499f4eae339acf78e8dbb4d6c0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "9983a1c945f8f5201e7d02c77360261487f920f8dfa496ecb7ded9f78c8524d6"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e2662dc58792c8acff07d745e88026a58ad2916aa943f03e214861ffff83ced8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e2662dc58792c8acff07d745e88026a58ad2916aa943f03e214861ffff83ced8"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e2662dc58792c8acff07d745e88026a58ad2916aa943f03e214861ffff83ced8"
    sha256 cellar: :any_skip_relocation, sonoma:         "74980aa1fd15aa5912bf5375ea00aa5a2a8421fcdca1bf2b16ac57cd7a5674b2"
    sha256 cellar: :any_skip_relocation, ventura:        "9c458fa964243f8611a16564f9afc526a101cc2c1167a0f1dd85def0cd35ce20"
    sha256 cellar: :any_skip_relocation, monterey:       "9c458fa964243f8611a16564f9afc526a101cc2c1167a0f1dd85def0cd35ce20"
    sha256 cellar: :any_skip_relocation, big_sur:        "9c458fa964243f8611a16564f9afc526a101cc2c1167a0f1dd85def0cd35ce20"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "5e13027ed0061e9a3186260bd32df2b98f18315033bd208442963b289d010086"
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
