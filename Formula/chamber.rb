class Chamber < Formula
  desc "CLI for managing secrets through AWS SSM Parameter Store"
  homepage "https://github.com/segmentio/chamber"
  url "https://github.com/segmentio/chamber/archive/v2.10.2.tar.gz"
  sha256 "50e8bf541aac590a7eefbee7fe4d064a4bf23ddc8d83bbb81921f8b38c497299"
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
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6aae4dced4d18178af803ec55273c08523f24069876d676230e40298f8355e5a"
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
