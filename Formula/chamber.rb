class Chamber < Formula
  desc "CLI for managing secrets through AWS SSM Parameter Store"
  homepage "https://github.com/segmentio/chamber"
  url "https://github.com/segmentio/chamber/archive/v2.10.1.tar.gz"
  sha256 "ea1ddb05a5dbfbd23ab08f004eb2442366b1a33515333cc3a9b747e5c2424640"
  license "MIT"
  head "https://github.com/segmentio/chamber.git"

  livecheck do
    url :stable
    regex(%r{href=.*?/tag/v?(\d+(?:\.\d+)+(?:-ci\d)?)["' >]}i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "ef86cc1dcd611f94f7ab59377bdc04a4d716f9a782fa17be887551af5629f14d"
    sha256 cellar: :any_skip_relocation, big_sur:       "4aa6c179d62dc7c35f630d8aa3f8c23030cd41bcf8ae8d175dd7851ea67ca0cf"
    sha256 cellar: :any_skip_relocation, catalina:      "08e0dfec7c1f00660daa2c5637d2609a05e364a95e28e79997058aabf3fa0078"
    sha256 cellar: :any_skip_relocation, mojave:        "a7298287685510c1d50a285ee305c04d86c1ceb35be53aa6294802a51f82becd"
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
