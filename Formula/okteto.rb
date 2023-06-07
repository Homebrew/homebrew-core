class Okteto < Formula
  desc "Build better apps by developing and testing code directly in Kubernetes"
  homepage "https://okteto.com"
  url "https://github.com/okteto/okteto/archive/2.16.3.tar.gz"
  sha256 "92c31c73248f2acaa92248702a2feec4eca2b36808335f7a66c79408539f39f9"
  license "Apache-2.0"
  head "https://github.com/okteto/okteto.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1065ed4fbf4ce67e1de35689adf34dc75f7d773bfe6efb5822bd6b93adc3fbef"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bf17e58e1ea4f9d8a916c2c862f55c7f6fce5a134e6c4d4af9f7a7f80c5c01d5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b6c82d1747ec74024c637bfef5f90375c1d5fea3fc986137ff8f7fe9dac54f57"
    sha256 cellar: :any_skip_relocation, ventura:        "5e752fcd5c20f6654a09cffbabbe791f61b5e0a08426163054aea9c10caf5b1e"
    sha256 cellar: :any_skip_relocation, monterey:       "1fec2f5e20635ef44dee033ca4c0e7f7e6d21155269fbddb13f00f73d8b7c71c"
    sha256 cellar: :any_skip_relocation, big_sur:        "aa6ced76642006b36b011e7814d1556970d0a590ddb14e2ec10c2db7d99f8ac2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6401e3a21d6021037a073ea6f5eb7b8047d0099a40a4d71eb692931912ac9431"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/okteto/okteto/pkg/config.VersionString=#{version}"
    tags = "osusergo netgo static_build"
    system "go", "build", *std_go_args(ldflags: ldflags), "-tags", tags

    generate_completions_from_executable(bin/"okteto", "completion")
  end

  test do
    assert_match "okteto version #{version}", shell_output("#{bin}/okteto version")

    assert_match "Please run 'okteto context' to select one context",
      shell_output(bin/"okteto init --context test 2>&1", 1)

    assert_match "Your context is not set",
      shell_output(bin/"okteto context list 2>&1", 1)
  end
end
