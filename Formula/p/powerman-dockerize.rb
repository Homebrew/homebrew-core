class PowermanDockerize < Formula
  desc "Utility to simplify running applications in docker containers"
  homepage "https://github.com/powerman/dockerize"
  url "https://github.com/powerman/dockerize.git",
      tag:      "v0.24.3",
      revision: "a21f69ff60cdf1b2d54dadb7d04f28c8b6723c19"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ea36ce1326cf135d59fb62ab94d4d9a86bcd8c26271b2a0d36a73a9e48665e43"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ea36ce1326cf135d59fb62ab94d4d9a86bcd8c26271b2a0d36a73a9e48665e43"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ea36ce1326cf135d59fb62ab94d4d9a86bcd8c26271b2a0d36a73a9e48665e43"
    sha256 cellar: :any_skip_relocation, sonoma:        "1ab2896f5416a6f8b1d29d2419793757bd25c1aa3e36fd7c95be6b1cd83a0cc3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0e68e24d383c5df34414a26b602129b898873a4cd7f34068205c52d08a96e154"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "76ae163fbb8d52e493a73f2f6c8e02dd12e4b02a654b6bc4a7ada9bb61778aca"
  end

  depends_on "go" => :build
  conflicts_with "dockerize", because: "powerman-dockerize and dockerize install conflicting executables"

  def install
    system "go", "build", *std_go_args(output: bin/"dockerize", ldflags: "-s -w")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/dockerize --version")
    system bin/"dockerize", "-wait", "https://www.google.com/", "-wait-retry-interval=1s", "-timeout", "5s"
  end
end
