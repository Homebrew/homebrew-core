class Gtree < Formula
  desc "Generate directory trees and directories using Markdown or programmatically"
  homepage "https://ddddddo.github.io/gtree/"
  url "https://github.com/ddddddO/gtree/archive/refs/tags/v1.14.5.tar.gz"
  sha256 "11f008fd9802d519efe8267e944546fe1ee07f25fe2437e161c370282f5831db"
  license "BSD-2-Clause"
  head "https://github.com/ddddddO/gtree.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "944b681c366d9ae796f394d9f4654fe503599966cb653760507009582038fd36"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "944b681c366d9ae796f394d9f4654fe503599966cb653760507009582038fd36"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "944b681c366d9ae796f394d9f4654fe503599966cb653760507009582038fd36"
    sha256 cellar: :any_skip_relocation, sonoma:        "ae77212636593b0e190e4d4a53ab03b423221d0827adbde79ecf723d32f7d9a9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5b1aff5da08a38ff1abcd635b4146e385e493ec642bee860d9e99f7bbd150374"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8d675922abbcb2500377d61293e74fbffe64c9906ce83aa030f90be0ebaa8f5f"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.Version=#{version} -X main.Revision=#{tap.user}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/gtree"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gtree version")

    assert_match "testdata", shell_output("#{bin}/gtree template")
  end
end
