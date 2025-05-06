class Glab < Formula
  desc "Open-source GitLab command-line tool"
  homepage "https://gitlab.com/gitlab-org/cli"
  url "https://gitlab.com/gitlab-org/cli.git",
    tag:      "v1.57.0",
    revision: "d14f47ce8f09549daf116e347cd1c2987aa14bbb"
  license "MIT"
  head "https://gitlab.com/gitlab-org/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c347680d5d542b2bdc0f16bb3ac7bc079b6eade92e9ec1ecdda91a24662c74a9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c347680d5d542b2bdc0f16bb3ac7bc079b6eade92e9ec1ecdda91a24662c74a9"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c347680d5d542b2bdc0f16bb3ac7bc079b6eade92e9ec1ecdda91a24662c74a9"
    sha256 cellar: :any_skip_relocation, sonoma:        "785b849e8729c5a877c7fce3dd2c6df5c201f54e583c579d62dd3145802bd69c"
    sha256 cellar: :any_skip_relocation, ventura:       "785b849e8729c5a877c7fce3dd2c6df5c201f54e583c579d62dd3145802bd69c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6c7ac4a8ec56a0bafe19f90aff32fea4b2a9c319345791f0763143bd9ed22258"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b313e54c4e536c8405676916684a03907dc23519cea2c2bed17ad49b98663167"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "1" if OS.mac?
    system "make"
    bin.install "bin/glab"
    generate_completions_from_executable(bin/"glab", "completion", "--shell")
  end

  test do
    system "git", "clone", "https://gitlab.com/cli-automated-testing/homebrew-testing.git"
    cd "homebrew-testing" do
      assert_match "Matt Nohr", shell_output("#{bin}/glab repo contributors")
      assert_match "This is a test issue", shell_output("#{bin}/glab issue list --all")
    end
  end
end
