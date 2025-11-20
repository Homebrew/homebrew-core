class Okteto < Formula
  desc "Build better apps by developing and testing code directly in Kubernetes"
  homepage "https://okteto.com"
  url "https://github.com/okteto/okteto/archive/refs/tags/3.13.2.tar.gz"
  sha256 "da3260d3bf92a7a5f962b86022dd7cbcc4b7bf9694b7a4c43963970d842677e2"
  license "Apache-2.0"
  head "https://github.com/okteto/okteto.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "53b98d5b01ea07c24c7528dc69f5d040949b7630adc33a04ea298177c577699b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1dbdfb0b302d07bb81f6630a24085ea166a5a1572c810b500292154d507cd7ac"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2a037387f7f994b564adebc6a60a44ea4257571709f74d184ec0b349d6e6f5fd"
    sha256 cellar: :any_skip_relocation, sonoma:        "1faf16f6d9b4578dec6ae29c96b34a4507a92f7938eb96814a81436d643cd734"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "863ac604b1e06a2bd0566000cd32e594cbb82e52c659bdc1165b2cf3d187298f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "86075e7684552e054c3922c4167918f9220fcd06a4e0a307e0046cb04d9fe1ed"
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
