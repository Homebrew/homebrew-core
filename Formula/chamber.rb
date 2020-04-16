class Chamber < Formula
  desc "CLI for managing secrets through AWS SSM Parameter Store"
  homepage "https://github.com/segmentio/chamber"
  url "https://github.com/segmentio/chamber/archive/v2.8.1.tar.gz"
  sha256 "ec067de2ce3ddc208075170d551f8d8579ac122ffa785fe7bad65b5946a5a6bf"
  head "https://github.com/segmentio/chamber.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "ae3e966b45fd10fdd9a6c9d5e06814b658fa5a490c18948a24ba1919a537a5a7" => :catalina
    sha256 "11fd8cbfe6c0592badaf3493f2a9507a48f8c1b8097e5554d1976c0c02bb91c9" => :mojave
    sha256 "63510e601f8d06882306c5ddb161553d3a3af09f0d6edbad8912ccd23b36a526" => :high_sierra
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
