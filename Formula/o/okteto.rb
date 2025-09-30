class Okteto < Formula
  desc "Build better apps by developing and testing code directly in Kubernetes"
  homepage "https://okteto.com"
  url "https://github.com/okteto/okteto/archive/refs/tags/3.12.0.tar.gz"
  sha256 "02cfab8f5319642b2ca81d2f12b5f2ac71921fb639f7ed5268fa6e247be0accf"
  license "Apache-2.0"
  head "https://github.com/okteto/okteto.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5b2d4345ee14ba74eda634aeac0b4231727ab2d5b9c84dba5a3d43343dff06db"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ecbbc7153fededbd9068e0a1d449821385d75a61f1a4b0f267e095baa848fb2b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "315dcba8c779d1216310cccc1ae51647f496fa6b86f28bc01881ba58fc805866"
    sha256 cellar: :any_skip_relocation, sonoma:        "a5ce96b18b7248661430dd1bd995878f9e1bcd4baecb5353791581a668d54fca"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9b4f69b4e532569a070ec2dfe4fa49b81bad8a7adb03957cc01fc6a17ec66481"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c85a97b9597e8e4780ce2a97e3c26165430acc058c9e367f2c2c8176adbd957b"
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
