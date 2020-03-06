class Chamber < Formula
  desc "CLI for managing secrets through AWS SSM Parameter Store"
  homepage "https://github.com/segmentio/chamber"
  url "https://github.com/segmentio/chamber/archive/v2.8.0.tar.gz"
  sha256 "965c4dc2bf274538c6e6aa5a917f5b220424c91f2bfb0c1170382ace10bdba59"
  head "https://github.com/segmentio/chamber.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "493649fc1bfe2ac8ac76b0b97f68b181459020ec1a0a7ce5ef3f93dab801b94c" => :catalina
    sha256 "21221372fcf06090c02801dcaed36a8da62ed05fd8bbc12c2f9533ad8376bb9d" => :mojave
    sha256 "aeb39f2d163855cd7bbc71456ede11b08fc13a1b68c1c88c2276e8d8cc003fad" => :high_sierra
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
