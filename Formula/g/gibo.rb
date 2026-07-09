class Gibo < Formula
  desc "Access GitHub's .gitignore boilerplates"
  homepage "https://github.com/simonwhitaker/gibo"
  url "https://github.com/simonwhitaker/gibo/archive/refs/tags/v3.0.22.tar.gz"
  sha256 "1c9432a3bd417709fee9a475b85dc0dbfa10e62676b54e8f3ea4d7c44f6e16b3"
  license "Unlicense"
  head "https://github.com/simonwhitaker/gibo.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9f36adffec0e7abee1a6b7cdf5553a3fd2413dd515baa7c3917a3ec2900e1c4a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9f36adffec0e7abee1a6b7cdf5553a3fd2413dd515baa7c3917a3ec2900e1c4a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9f36adffec0e7abee1a6b7cdf5553a3fd2413dd515baa7c3917a3ec2900e1c4a"
    sha256 cellar: :any_skip_relocation, sonoma:        "4c94c21865d0bf2afc977fd3855f7b22e078838cd72b75048a83597ebf22f241"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "92a77a1c79c79ded4590bfd4974d2ef0e88e9c1c7785de01e6aa89cc1b516df6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "276a77ff12b5b3fe3f401db3993dd21c9d9a5138e926014ee28f81e16107a527"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/simonwhitaker/gibo/cmd.version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:)
    generate_completions_from_executable(bin/"gibo", shell_parameter_format: :cobra)
  end

  test do
    system bin/"gibo", "update"
    assert_includes shell_output("#{bin}/gibo dump Python"), "Python.gitignore"

    assert_match version.to_s, shell_output("#{bin}/gibo version")
  end
end
