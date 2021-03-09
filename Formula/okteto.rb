class Okteto < Formula
  desc "Build better apps by developing and testing code directly in Kubernetes"
  homepage "https://okteto.com"
  url "https://github.com/okteto/okteto/archive/1.11.3.tar.gz"
  sha256 "ca75d483f347632be344ebeca3e8d3c79ab4d9255ae46005f6169b4a06d00baa"
  license "Apache-2.0"
  head "https://github.com/okteto/okteto.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "2cdb4b07a963f5a52f466c40bb43c6c7b271e24a2a1cf7070f77b693620051f7"
    sha256 cellar: :any_skip_relocation, big_sur:       "355b63d944546eab4e66101a1856573b3ff87c637dee4bed632de96ecc552756"
    sha256 cellar: :any_skip_relocation, catalina:      "d77d4e4f05ef3aaf19d9f5eb7a07b2a2a6d88fb5bc32fd716f3f3e0adf73df2a"
    sha256 cellar: :any_skip_relocation, mojave:        "52640fce55383e529b20efc7e000c46b9c30051167e73c887f8a1fcd79e9c7f4"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/okteto/okteto/pkg/config.VersionString=#{version}"
    tags = "osusergo netgo static_build"
    system "go", "build", *std_go_args, "-ldflags", ldflags, "-tags", tags
  end

  test do
    assert_match "okteto version #{version}", shell_output("#{bin}/okteto version")

    touch "test.rb"
    assert_match "Failed to load your local Kubeconfig",
      shell_output("echo | #{bin}/okteto init --overwrite --file test.yml 2>&1")
  end
end
