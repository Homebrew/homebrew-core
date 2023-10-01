class Okteto < Formula
  desc "Build better apps by developing and testing code directly in Kubernetes"
  homepage "https://okteto.com"
  url "https://github.com/okteto/okteto/archive/2.20.0.tar.gz"
  sha256 "7cf5dee99fb287457b1bf6f8cbb1e81cc5036cb40115034893534df43da96fc9"
  license "Apache-2.0"
  head "https://github.com/okteto/okteto.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a732c8e8da1f13e9e2566eefc51958ea0cd875cfea1672e028eb2964ec04a675"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b296c0d0204e27bf1529cdb44c49d5d4d9827ff8d0740d6a289a9eb790b59ec4"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8339f166e99c53515efa92676dbbed4c9485eb513f0715d413e760041c5d191d"
    sha256 cellar: :any_skip_relocation, ventura:        "2bcfd12a462f32562d78f2867fc40af45cbbdfe5c155942b49cc97663ea5fc27"
    sha256 cellar: :any_skip_relocation, monterey:       "f2771144198f2e677adb953af3756bcff4cc394a07b3f9d2a6b0f65164672ef3"
    sha256 cellar: :any_skip_relocation, big_sur:        "c2a642ecd2635c82c903ca4ce771ae5a3c77bcd278757072d7ab5bf38b95aa93"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7a64c8714f4fba0b37d7c971d4e6d00c6609d9f1147224a664554aee5cce1f1f"
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
