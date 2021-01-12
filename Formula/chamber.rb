class Chamber < Formula
  desc "CLI for managing secrets through AWS SSM Parameter Store"
  homepage "https://github.com/segmentio/chamber"
  url "https://github.com/segmentio/chamber/archive/v2.9.1.tar.gz"
  sha256 "184f5fe1e7a6892434d8a3f12f200f3b0fb2d77699de07e9f0a09a38f3a8297c"
  license "MIT"
  head "https://github.com/segmentio/chamber.git"

  livecheck do
    url :stable
    regex(%r{href=.*?/tag/v?(\d+(?:\.\d+)+(?:-ci\d)?)["' >]}i)
    strategy :github_latest
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "f8d3c3b564b93f43dad680f787460c1784e06d4e554941b6d861721d45fb0b74" => :big_sur
    sha256 "cd6eff9b5fbcf19d4e2dc91a7a42342162609340a45a8331bce8b9be5a4da189" => :arm64_big_sur
    sha256 "57e650471ca7d31a25ce528576fb38e789563daa7f66a45306d9bd00b555658a" => :catalina
    sha256 "6519293120c945ebda5d7873790df30e4ed6d46a48ef0a1b111babc0ff2221b9" => :mojave
    sha256 "2490e40a1d9f2f4a31f38c9e8023a5fbc1ed3220022a910b9a0acb9dfa76cfde" => :high_sierra
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
