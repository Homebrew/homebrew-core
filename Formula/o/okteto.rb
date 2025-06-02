class Okteto < Formula
  desc "Build better apps by developing and testing code directly in Kubernetes"
  homepage "https://okteto.com"
  url "https://github.com/okteto/okteto/archive/refs/tags/3.7.0.tar.gz"
  sha256 "d546611c64d7e39a65bae28a44e878c21f1ef759ab2ae0a26cf5573b1074d84f"
  license "Apache-2.0"
  head "https://github.com/okteto/okteto.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "2e7afd43d02b1f5421ac7180bc828cf7ba2c8c4118b56d28b78a18a88a4ccd69"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "02e8454db51f7dbf0b53eceb8da1570df68e6b12f1e920321ce866d344db02af"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "cc1006702348ce55fe47c8f94c9b814170ea98ac17f966f2bb0d76b04ae1d686"
    sha256 cellar: :any_skip_relocation, sonoma:        "bbf2dac62f3aa45545082188ece218d08d34251c6e4a0d116ad2b8cc7c5cc8f7"
    sha256 cellar: :any_skip_relocation, ventura:       "67582281b1bd37c1c8eff1c1d84a4b804ed45dc8b4fc5f71d2f44af87b2dd29b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a57f6bffccfe635b3fe6a890cc9a69a1efd1cdf1686e81ad3368c52db99a7878"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "de0800a06c51a01f9d4cf6e02028279578b21c67415ec25e8e04158c6c38d98d"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/okteto/okteto/pkg/config.VersionString=#{version}"
    tags = "osusergo netgo static_build"
    system "go", "build", *std_go_args(ldflags:, tags:)

    generate_completions_from_executable(bin/"okteto", "completion")
  end

  test do
    assert_match "okteto version #{version}", shell_output("#{bin}/okteto version")

    assert_match "Your context is not set", shell_output("#{bin}/okteto context list 2>&1", 1)
  end
end
