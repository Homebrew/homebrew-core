class Dependabot < Formula
  desc "Tool for testing and debugging Dependabot update jobs"
  homepage "https://github.com/dependabot/cli"
  url "https://github.com/dependabot/cli/archive/refs/tags/v1.79.0.tar.gz"
  sha256 "b6a691512902236adffe823047b322e5fe168ab668e6336f39608de2b9364038"
  license "MIT"
  head "https://github.com/dependabot/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8b8543719295fe6ff27eb6b49149e6afeb8481529de21cc9109fc18df9da9d2b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8b8543719295fe6ff27eb6b49149e6afeb8481529de21cc9109fc18df9da9d2b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8b8543719295fe6ff27eb6b49149e6afeb8481529de21cc9109fc18df9da9d2b"
    sha256 cellar: :any_skip_relocation, sonoma:        "5e5ca46bc9709af7d0aa6b392fa6b448575438500141ede4d12299b599cb8c2d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9af4586d28734b4a277a0ecbf40890efed147b13bb1b564ebe486e8a7c2b57bf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a96ec7e4ae4c5fc8d754a0349db96253534af8b1841e2caa5746d242df5ff884"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/dependabot/cli/cmd/dependabot/internal/cmd.version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/dependabot"

    generate_completions_from_executable(bin/"dependabot", "completion")
  end

  test do
    ENV["DOCKER_HOST"] = "unix://#{testpath}/invalid.sock"
    assert_match("dependabot version #{version}", shell_output("#{bin}/dependabot --version"))
    output = shell_output("#{bin}/dependabot update bundler Homebrew/homebrew 2>&1", 1)
    assert_match("Cannot connect to the Docker daemon", output)
  end
end
