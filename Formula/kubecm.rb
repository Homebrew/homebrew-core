class Kubecm < Formula
  desc "KubeConfig Manager"
  homepage "https://kubecm.cloud"
  url "https://github.com/sunny0826/kubecm/archive/v0.23.0.tar.gz"
  sha256 "dac22e2492e61ef45077fbc45bd43a1a9fbaa6da76c32684cb48145e474d79fd"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "29138226652b47efa877da6e904480531fe8c4d6cc68f2b19b4a68d9d5ceab20"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b44f6c7a06297fab9cb67d232a55d51d98f91a8fb854e3590b8b2a8a3b54d4cc"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "29138226652b47efa877da6e904480531fe8c4d6cc68f2b19b4a68d9d5ceab20"
    sha256 cellar: :any_skip_relocation, ventura:        "73c2f885654d2e9fc302ec2c2bf11dd6a629a955bb64e8c56841862578bc8a1d"
    sha256 cellar: :any_skip_relocation, monterey:       "8e03b89e8397abc670f0667922a663f796269088f389f095e2099350f65b8e4e"
    sha256 cellar: :any_skip_relocation, big_sur:        "8e03b89e8397abc670f0667922a663f796269088f389f095e2099350f65b8e4e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "667895bd4619c145be0eefb657e6837bceb34c0474da574abd1f3c2bb0807d0c"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/sunny0826/kubecm/version.Version=#{version}"
    system "go", "build", *std_go_args(ldflags: ldflags)

    generate_completions_from_executable(bin/"kubecm", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/kubecm version")
    # Should error out as switch context need kubeconfig
    assert_match "Error: open", shell_output("#{bin}/kubecm switch 2>&1", 1)
  end
end
