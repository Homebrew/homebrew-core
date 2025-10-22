class Azqr < Formula
  desc "Azure Quick Review"
  homepage "https://azure.github.io/azqr/"
  # pull from git tag to get submodules
  url "https://github.com/Azure/azqr.git",
      tag:      "v.2.11.1",
      revision: "3e1ea6238d6d34d81a527973b3f65013cee4c36a"
  license "MIT"
  head "https://github.com/Azure/azqr.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0a71eaf129cf1b56cb82bc495aaa31c385cd2c4545506bc743e1c8572bed730c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0a71eaf129cf1b56cb82bc495aaa31c385cd2c4545506bc743e1c8572bed730c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0a71eaf129cf1b56cb82bc495aaa31c385cd2c4545506bc743e1c8572bed730c"
    sha256 cellar: :any_skip_relocation, sonoma:        "6ebfcc1eb5bb7e0065702e99cb2a3ea6f38ec9829718757137cf194d1cdfc38b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f2f41802e614d501ae858592f8f9b897e2f5f46e72a5eb02e4730548e7db487e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "50d550ad6f87692129a100308d14234085eb633952dc234b4f77f8829be438c6"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/Azure/azqr/cmd/azqr/commands.version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/azqr"

    generate_completions_from_executable(bin/"azqr", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/azqr -v")
    output = shell_output("#{bin}/azqr scan --filters notexists.yaml 2>&1", 1)
    assert_includes output, "failed reading data from file"
    output = shell_output("#{bin}/azqr scan 2>&1", 1)
    assert_includes output, "Failed to list subscriptions"
  end
end
