class Leetgo < Formula
  desc "CLI tool for LeetCode"
  homepage "https://github.com/j178/leetgo"
  url "https://github.com/j178/leetgo/archive/refs/tags/v1.4.17.tar.gz"
  sha256 "e5319326ad10bd0de452e5ec027e2c8f83ac05eea25662ca3e98658cc4798c16"
  license "MIT"
  head "https://github.com/j178/leetgo.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d513da08f10a465c62eea61bd9cf0c770d3b82a8310ab8c788d2ee4ac88d20ea"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "11a62fd439fe559d59c0de6f4fcc270bd024d897fd33ac804d396869f81a752f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f9c731806de9feb62d6db878df5da632a27980c58274a39c6a92ed740d50653d"
    sha256 cellar: :any_skip_relocation, sonoma:        "82101eda9995fdd25417518c5ba71ad0180b70d098cf3737bc1d4913a24c80d8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3457c3699d9f33385fa0359a4e809b44287a1fa6f65c1065ac28fe84798b8174"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "510997fbadc32f9759af0046a52029e2a7f02fb74519a67429bc2d68f7e8de28"
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
