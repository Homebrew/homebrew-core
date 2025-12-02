class Forcecli < Formula
  desc "Command-line interface to Force.com"
  homepage "https://force-cli.herokuapp.com/"
  url "https://github.com/ForceCLI/force/archive/refs/tags/v1.5.0.tar.gz"
  sha256 "cabe517926c2d8a4ff6a3febb387c0953778611000cc39744b145ed7d8829bbc"
  license "MIT"
  head "https://github.com/ForceCLI/force.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3e60a77fa6b93b645b4f3180eb7e7c6d2aaedcb0f7923dd10ca389f79b859a86"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3e60a77fa6b93b645b4f3180eb7e7c6d2aaedcb0f7923dd10ca389f79b859a86"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3e60a77fa6b93b645b4f3180eb7e7c6d2aaedcb0f7923dd10ca389f79b859a86"
    sha256 cellar: :any_skip_relocation, sonoma:        "4f78a475d5a845b6c25e65e355044822683a2d4e393ed948caf01a347777e260"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4aea5100928b4404cbedfae4ab8ca082047d0776d653f5402d3e0062c592c30d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2256911fb347c49deac84bdb2bdf77746c154633fd1785fd0ab762b1308485d0"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w", output: bin/"force")

    generate_completions_from_executable(bin/"force", "completion")
  end

  test do
    assert_match "ERROR: Please login before running this command.",
                 shell_output("#{bin}/force active 2>&1", 1)
  end
end
