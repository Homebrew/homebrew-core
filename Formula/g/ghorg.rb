class Ghorg < Formula
  desc "Quickly clone an entire org's or user's repositories into one directory"
  homepage "https://github.com/gabrie30/ghorg"
  url "https://github.com/gabrie30/ghorg/archive/refs/tags/v1.11.9.tar.gz"
  sha256 "31df84957a65f32b62e1fd0255642341af40e9acc793a5f29678746c65ecc7a4"
  license "Apache-2.0"
  head "https://github.com/gabrie30/ghorg.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7d4d31a6dd0710099eb604afcbcec4811847e65e1d575a46558a2f6f25360275"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7d4d31a6dd0710099eb604afcbcec4811847e65e1d575a46558a2f6f25360275"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7d4d31a6dd0710099eb604afcbcec4811847e65e1d575a46558a2f6f25360275"
    sha256 cellar: :any_skip_relocation, sonoma:        "4ad284fae0cf64d3afa5a2a14b87ab47a5ae18a4dec215336492e3bf1ef2c333"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a82663674b71b9427afff1fa134008c11e77a4f7d388c7b45638fac87908f99f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d29d356f9c9a0879f23e2200fdd0c9fe52a0ef8697e1e1bd393af2846ace8387"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")

    generate_completions_from_executable(bin/"ghorg", shell_parameter_format: :cobra)
  end

  test do
    assert_match "No clones found", shell_output("#{bin}/ghorg ls")
  end
end
