class Okteto < Formula
  desc "Build better apps by developing and testing code directly in Kubernetes"
  homepage "https://okteto.com"
  url "https://github.com/okteto/okteto/archive/refs/tags/2.25.3.tar.gz"
  sha256 "f8ed10e0318d423a5d188de75b9c4efd974601348fc87a1f3d1597327eeb4d7a"
  license "Apache-2.0"
  head "https://github.com/okteto/okteto.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "dd09188c8e7f878437b7cdeaffcc8d33dc540681ef2e5c05a642ce9cdb0a4334"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "cba89ce1002f268b1e9a247774dfba41588c39bb71ce7153e34ef0197bc1ca51"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1b51d3e7c0d25601625f51e05af20412370652459cc2772160986f58153f818e"
    sha256 cellar: :any_skip_relocation, sonoma:         "bf798e5c2f82a7a29507d1ecab135d46cf960c801682fe18aadc11e2808d3cf0"
    sha256 cellar: :any_skip_relocation, ventura:        "aa29afcb031f1faf03fd0c080e45909a4f00840a14b717ce40143c0db89197d4"
    sha256 cellar: :any_skip_relocation, monterey:       "9321d8e631e0b4abcc8de297301520c2212288e741487f0ddaf1f45ca4a55c66"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "45f70bed93849200a89ff5dac4087c6be65331e6f19c7b28bbfea9682868546f"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/okteto/okteto/pkg/config.VersionString=#{version}"
    tags = "osusergo netgo static_build"
    system "go", "build", *std_go_args(ldflags:), "-tags", tags

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
