class Okteto < Formula
  desc "Build better apps by developing and testing code directly in Kubernetes"
  homepage "https://okteto.com"
  url "https://github.com/okteto/okteto/archive/2.10.3.tar.gz"
  sha256 "3f36e3cc6cf68605e83981df252ba4d18cc2fe30e3a6333772ba2a42cfe5871d"
  license "Apache-2.0"
  head "https://github.com/okteto/okteto.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3c319fb04dcc2e247c7f3d8b5e84f21ca4226ceb581a7d52f44749e54123820e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "58dc7eb63b41b60cc23755804557a306561729e65793f7860a622b10831ae526"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "085bb255c2e1d96c5250a9f394a7fd3fec13eb176854d3db40f4c8d1e67b1d65"
    sha256 cellar: :any_skip_relocation, ventura:        "5e6f0d15e3096efdef0592a02f9a82a64a29265698e7251e295a3d6022958d81"
    sha256 cellar: :any_skip_relocation, monterey:       "461f37f529e57b8fc2130d8ccb9ce7e3a23c7916cf9a2e2d4843c6d2cb377d1d"
    sha256 cellar: :any_skip_relocation, big_sur:        "0d0d39fe5718d092fddb46a1eed312b4527d7c2bb8dc0a8096931a3b4ce7a10f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e60ab59195c0c49463edc088bf2a136a1c73c4c970800fda75f346667ec3737e"
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
