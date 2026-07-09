class Forcecli < Formula
  desc "Command-line interface to Force.com"
  homepage "https://force-cli.herokuapp.com/"
  url "https://github.com/ForceCLI/force/archive/refs/tags/v1.13.0.tar.gz"
  sha256 "8ada253bbb81ca0d5d686964a0ba3418296473dc7e1c8e4f19a5f3df42fa1eb2"
  license "MIT"
  head "https://github.com/ForceCLI/force.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "78529fb73d4130221b347ee65032dfca6303cc2987077453bfca2e2204f9b031"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "78529fb73d4130221b347ee65032dfca6303cc2987077453bfca2e2204f9b031"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "78529fb73d4130221b347ee65032dfca6303cc2987077453bfca2e2204f9b031"
    sha256 cellar: :any_skip_relocation, sonoma:        "98ebc0c3e2d9a6c3d1531b7d12f5fbce17a3adea6cec461323ea4722079979d1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4b36063db087a453be766ce6544a02cd808ad68df667d4fb4b5ae582abc5b032"
    sha256 cellar: :any,                 x86_64_linux:  "f1e7ceef8a2093f725650c0cede2ff8dd25f662ce86b835280e77491d22fb9f0"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w", output: bin/"force")

    generate_completions_from_executable(bin/"force", shell_parameter_format: :cobra)
  end

  test do
    assert_match "ERROR: Please login before running this command.",
                 shell_output("#{bin}/force active 2>&1", 1)
  end
end
