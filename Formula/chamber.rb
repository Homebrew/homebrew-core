class Chamber < Formula
  desc "CLI for managing secrets through AWS SSM Parameter Store"
  homepage "https://github.com/segmentio/chamber"
  url "https://github.com/segmentio/chamber/archive/v2.10.8.tar.gz"
  sha256 "3d6cd696438994c029e9ff6130baf8ea7fdd32aa17a4c9e88e5c4c05cbb71409"
  license "MIT"
  head "https://github.com/segmentio/chamber.git", branch: "master"

  livecheck do
    url :stable
    regex(%r{href=.*?/tag/v?(\d+(?:\.\d+)+(?:-ci\d)?)["' >]}i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "69b6be491b4e21f5402f3d12c5b0bb293ef294275dab83b2ff8c377174fc9b7d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "357f3da41c7a1ede875502401f41e7577598bd1997e7401375eb229915fc25b7"
    sha256 cellar: :any_skip_relocation, monterey:       "1dc9300e75c3b3b6133eeb06e85477fd1d87976187630a046dbce49492b25602"
    sha256 cellar: :any_skip_relocation, big_sur:        "89a69a5d0e587d2ec4c98e04646c790ee34364efa8c16fdee57ba901fe55c88c"
    sha256 cellar: :any_skip_relocation, catalina:       "58a73003ee6317a20b1a7640117bc12b1203e2f15222722063a1f383167762f9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a3196c8dbea0cb52c1122ceb7ad314534151980da1055ee1f4bb7c127f6f9c52"
  end

  depends_on "go" => :build

  def install
    system "go", "build", "-ldflags", "-s -w -X main.Version=v#{version}", "-trimpath", "-o", bin/"chamber"
    prefix.install_metafiles
  end

  test do
    ENV.delete "AWS_REGION"
    output = shell_output("#{bin}/chamber list service 2>&1", 1)
    assert_match "MissingRegion", output

    ENV["AWS_REGION"] = "us-west-2"
    output = shell_output("#{bin}/chamber list service 2>&1", 1)
    assert_match "NoCredentialProviders", output
  end
end
