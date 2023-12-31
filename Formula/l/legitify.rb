class Legitify < Formula
  desc "Tool to detect/remediate misconfig and security risks of GitHub/GitLab assets"
  homepage "https://legitify.dev/"
  url "https://github.com/Legit-Labs/legitify/archive/refs/tags/v1.0.7.tar.gz"
  sha256 "7f3d59141207d97579a4fbf6d787b1c522b840c2b2be79bac3e056829577040c"
  license "Apache-2.0"
  head "https://github.com/Legit-Labs/legitify.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "9853a395e30e5ed056d9f30d64452e4026a2eae8f51db98da5b8d68195d460d8"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7e43b34ba67e265b342fa55ae7787792aa43a60163f672ba31c1e6008272c5ab"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0215d3c767b73d7cf74ef2c6a4fa5d03a906ef55adcef722831f974db6509938"
    sha256 cellar: :any_skip_relocation, sonoma:         "5478047035e1fdcdd8b46c92dc2ef4760e581a94d8e9d26b41ab13520c39f57c"
    sha256 cellar: :any_skip_relocation, ventura:        "2d412ed0d61edb40cff321d85c3fa01a55ffc9c517b0dabb9cbd4aaede76ab02"
    sha256 cellar: :any_skip_relocation, monterey:       "03865b37838a0d833a5c9a3c942b36b86e4ff6a929a28958fc4821a849fc3063"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7b82c509695a08a9b4ae3c277084c878f8c5b7adb26ff650009a4142895166a1"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/Legit-Labs/legitify/internal/version.Version=#{version}
      -X github.com/Legit-Labs/legitify/internal/version.Commit=#{tap.user}
    ]

    system "go", "build", *std_go_args(ldflags: ldflags)

    generate_completions_from_executable(bin/"legitify", "completion")
  end

  test do
    output = shell_output("#{bin}/legitify generate-docs")
    assert_match "policy_name: actions_can_approve_pull_requests", output
    assert_match version.to_s, shell_output("#{bin}/legitify version")
  end
end
