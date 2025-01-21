class Glab < Formula
  desc "Open-source GitLab command-line tool"
  homepage "https://gitlab.com/gitlab-org/cli"
  url "https://gitlab.com/gitlab-org/cli/-/archive/v1.52.0/cli-v1.52.0.tar.gz"
  sha256 "585495e53d3994172fb927218627b7470678bc766320cb52f4b4204238677dde"
  license "MIT"
  head "https://gitlab.com/gitlab-org/cli.git", branch: "trunk"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "88c55668322cc683805c72db19532ab9de51ba0d754705b09894103603185c8f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "88c55668322cc683805c72db19532ab9de51ba0d754705b09894103603185c8f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "88c55668322cc683805c72db19532ab9de51ba0d754705b09894103603185c8f"
    sha256 cellar: :any_skip_relocation, sonoma:        "ba3b78a3e9cc6663095b1f10144f50d3fd6de5c250fa46f4f267014692d314c7"
    sha256 cellar: :any_skip_relocation, ventura:       "ba3b78a3e9cc6663095b1f10144f50d3fd6de5c250fa46f4f267014692d314c7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c4b9b83335efe0871e0afbbec376137ee83a26bbd46536dd4554419ffa7d2cdc"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "1" if OS.mac?

    system "make", "GLAB_VERSION=v#{version}"
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
