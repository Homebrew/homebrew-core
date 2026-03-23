class CloudNuke < Formula
  desc "CLI tool to nuke (delete) cloud resources"
  homepage "https://gruntwork.io/"
  url "https://github.com/gruntwork-io/cloud-nuke/archive/refs/tags/v0.47.0.tar.gz"
  sha256 "a97a1e35e4f00f44ade58c256e6cd6a94baa33c54d8592f7297d348100bb86a7"
  license "MIT"
  head "https://github.com/gruntwork-io/cloud-nuke.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "95b34eb7a105c83d038f7db62d68809d643e3e1b5f690bc2010c429c12a449c4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "95b34eb7a105c83d038f7db62d68809d643e3e1b5f690bc2010c429c12a449c4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "95b34eb7a105c83d038f7db62d68809d643e3e1b5f690bc2010c429c12a449c4"
    sha256 cellar: :any_skip_relocation, sonoma:        "d84e9a47fdafb73e2a29ea9de98ac788225af61c40a2495629f4847b3702ba30"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f9a8f253b4d8fb3dcb9b5e03238fb0dff865329407a4c39388fb2ba65e685186"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "83f1bce27354e2f685eb66a7e76dcbd149a608e04bc26da7f06ee1106937857f"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.VERSION=v#{version}")
  end

  test do
    assert_match "A CLI tool to nuke (delete) cloud resources", shell_output("#{bin}/cloud-nuke --help 2>1&")
    assert_match "ec2", shell_output("#{bin}/cloud-nuke aws --list-resource-types")
  end
end
