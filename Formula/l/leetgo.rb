class Leetgo < Formula
  desc "CLI tool for LeetCode"
  homepage "https://github.com/j178/leetgo"
  url "https://github.com/j178/leetgo/archive/refs/tags/v1.4.16.tar.gz"
  sha256 "56d733633e0632469f71d6d43893d7698bb768403f498511f01b3ef2b6108d3f"
  license "MIT"
  head "https://github.com/j178/leetgo.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a9c98a584d406afc2ca320717eba6d9346acdee631615efd12ac4970667b3a3d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "94028e3758ef790b62bce097247c1416f7cc194fbbe933db314de8c6dcbf9da3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4a144999c0cc08d53ade161ba6b3a1cf4f92fe490b1ef6e96b1589e50a5e0851"
    sha256 cellar: :any_skip_relocation, sonoma:        "63a4e37692d5d54314a46aa9bd34df6a9c0d02d34174d4fa47a5bc1b30504ca7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "76ecaf32b6e59b80998383b7f64daead8dbccf9fd42fea405e4f3425936bd863"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5f3f52df626997cceb49fe191f85f522217f84b721a1c45789e65679ed5aecae"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/j178/leetgo/constants.Version=#{version}
      -X github.com/j178/leetgo/constants.Commit=#{tap.user}
      -X github.com/j178/leetgo/constants.BuildDate=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:)
    generate_completions_from_executable(bin/"leetgo", shell_parameter_format: :cobra)
  end

  test do
    assert_match "leetgo version #{version}", shell_output("#{bin}/leetgo --version")
    system bin/"leetgo", "init", "--site", "us"
    assert_path_exists testpath/"leetgo.yaml"
  end
end
