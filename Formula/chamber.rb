class Chamber < Formula
  desc "CLI for managing secrets through AWS SSM Parameter Store"
  homepage "https://github.com/segmentio/chamber"
  url "https://github.com/segmentio/chamber/archive/v2.10.3.tar.gz"
  sha256 "2c68ceeddbc4147aef446ec4640957b58712f9d5e45e422b37d39e5d5e131c62"
  license "MIT"
  head "https://github.com/segmentio/chamber.git", branch: "master"

  livecheck do
    url :stable
    regex(%r{href=.*?/tag/v?(\d+(?:\.\d+)+(?:-ci\d)?)["' >]}i)
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "8fa4564b9bb8f89eb15ac6c583afaf7c5b1d181edda5b8e0f4a3f6493f76e2a8"
    sha256 cellar: :any_skip_relocation, big_sur:       "8a75e590e77af811bdeedbb3323e4e1f3f5c503d25607dece67a8285489ee940"
    sha256 cellar: :any_skip_relocation, catalina:      "3fad2fea5b6cf5d474beb168dd70476152e9794f44592f5ff5a1f5025da00863"
    sha256 cellar: :any_skip_relocation, mojave:        "ab84477a699e77f6494a43021427e3573d4ecf6b3c53779e1398cdcc848a63f6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3d94579c83432490351e3de81dc82da476abddb253e785b353e8ebe445cc8f4f"
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
