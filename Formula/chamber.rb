class Chamber < Formula
  desc "CLI for managing secrets through AWS SSM Parameter Store"
  homepage "https://github.com/segmentio/chamber"
  url "https://github.com/segmentio/chamber/archive/v2.8.0.tar.gz"
  sha256 "965c4dc2bf274538c6e6aa5a917f5b220424c91f2bfb0c1170382ace10bdba59"
  head "https://github.com/segmentio/chamber.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "a6c90839b66236da590a8977f8b68ddd240fe9f0f8f169b8220bc13b69d3089e" => :catalina
    sha256 "c8fa41272d55b997eb0e958c625baa766a65f91615e23d52dc09d7d98ca3d150" => :mojave
    sha256 "1aaa2e4f91a6b54ea26eedadce6b8991d6c2a171c7a80d1cba809a6b040df32a" => :high_sierra
  end

  depends_on "go" => :build

  def install
    system "go", "build", "-ldflags", "-s -w -X main.Version=#{version}", "-trimpath", "-o", bin/"chamber"
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
