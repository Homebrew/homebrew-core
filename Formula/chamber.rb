class Chamber < Formula
  desc "CLI for managing secrets through AWS SSM Parameter Store"
  homepage "https://github.com/segmentio/chamber"
  url "https://github.com/segmentio/chamber/archive/v2.8.2.tar.gz"
  sha256 "7f471abf96c92c619641d7a3fed130cddbd815c9c15fe2f151e6c981f5706584"
  license "MIT"
  head "https://github.com/segmentio/chamber.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "8371eee8ce1d24a682597422a12b651ef6cdbabe3ef81c9678ee8f460401d063" => :catalina
    sha256 "fe13b0ef1b110c43034f0e4ce3c414c68f199bcc5147ba2dda16608ab6673a05" => :mojave
    sha256 "948c865eb11c46e8d662dad8db21f39d53476a99bfb5475aa1fdb68b5cd86201" => :high_sierra
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
