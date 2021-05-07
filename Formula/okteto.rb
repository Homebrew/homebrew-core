class Okteto < Formula
  desc "Build better apps by developing and testing code directly in Kubernetes"
  homepage "https://okteto.com"
  url "https://github.com/okteto/okteto/archive/1.12.9.tar.gz"
  sha256 "442b03117a863b4e9e542772ad9e7fff1c7c1883f3d78aa0803cc9b52504d793"
  license "Apache-2.0"
  head "https://github.com/okteto/okteto.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "9279f543ee8c446bc390ccd5d4156a356ba69c5ce75fd831cef2b2613c4f6736"
    sha256 cellar: :any_skip_relocation, big_sur:       "79ff6a84b9683c8c6d8c49c68fc7b3f74a98fa6fafccd0d84aa899e520ce5703"
    sha256 cellar: :any_skip_relocation, catalina:      "bc8fcda81f3e3051851fc4c163e20f195b8ab9c27eb0ce620520fe2ab76693d0"
    sha256 cellar: :any_skip_relocation, mojave:        "5e8f28d507dedee0399dc80225cffd00221513c5df8d0db23cefcd3f3b38eed9"
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
