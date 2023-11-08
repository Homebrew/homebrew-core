class Okteto < Formula
  desc "Build better apps by developing and testing code directly in Kubernetes"
  homepage "https://okteto.com"
  url "https://github.com/okteto/okteto/archive/refs/tags/2.22.1.tar.gz"
  sha256 "063c406364bd2b9ca872be75cb075bb8823d716e58bf85342fa6fa3e30469dd9"
  license "Apache-2.0"
  head "https://github.com/okteto/okteto.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a2ed82f80beff8e6cf48981a207548982f063997332e6db55f49fc0e09085c8f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "82accac2fa6c1c5bc802fbfdf4df1d2a2ab680e0d2dea6e9ff3609402cf28896"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "541b5018444b43e012d9e9817b09becb128b57409046493a7542c5c0402ea63f"
    sha256 cellar: :any_skip_relocation, sonoma:         "49e765932f5cd0f0bb9a50eaaad730bb81e9fe4ba526d2652c85d76e1bbef659"
    sha256 cellar: :any_skip_relocation, ventura:        "d7a675cd1b28060e0aa2c5c523f018b1f4df54ab4de012674487c5a2a2747f4d"
    sha256 cellar: :any_skip_relocation, monterey:       "4d35735099a143448e147d4bff49a2b5eabd9c10e7b04d06b1d3e6a03cf3d6a3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c07371ddddc4946235ba51b0373d733c40c6669d42e4e89514a8226b5429a226"
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
