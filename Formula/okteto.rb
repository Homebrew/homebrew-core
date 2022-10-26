class Okteto < Formula
  desc "Build better apps by developing and testing code directly in Kubernetes"
  homepage "https://okteto.com"
  url "https://github.com/okteto/okteto/archive/2.8.2.tar.gz"
  sha256 "984bb75391e325be089adb1110ecfcf1c7065087c10c8fa6c4c91de26ebe853a"
  license "Apache-2.0"
  head "https://github.com/okteto/okteto.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "15f728a8b43fb4738d6dbfd4475d82810ef9fa7994892d64d5f529f04d67a970"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c4ea781602b83ed50304b0afc87e2b111c13b7c21eddc1412ad1a9afc4836a82"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "59a1ad7dadcbc715bb8195c2007e3530ae13637050f8cf6a95665897b09c9754"
    sha256 cellar: :any_skip_relocation, monterey:       "4c081328ba23edec456b26accf1d532df4a7322bc702ecb3868a6cab1550bf5e"
    sha256 cellar: :any_skip_relocation, big_sur:        "691459f4fa9fd2cff9865bb832be9bcc3283020f521bff2ef7f9e5b89944c56c"
    sha256 cellar: :any_skip_relocation, catalina:       "edacf158cddd9d02c0ab46ffa94c605dd6ad190fc2f87160bfe496c83c2597b6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "76815960ebe063e2085ab7d988565d34f27696b61c23ff7dd1b1d0123fd6891c"
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
