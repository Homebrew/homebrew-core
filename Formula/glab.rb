class Glab < Formula
  desc "Open-source GitLab command-line tool"
  homepage "https://gitlab.com/gitlab-org/cli"
  url "https://gitlab.com/gitlab-org/cli/-/archive/v1.28.0/cli-v1.28.0.tar.gz"
  sha256 "9a0b433c02033cf3d257405d845592e2b7c2e38741027769bb97a8fd763aeeac"
  license "MIT"
  head "https://gitlab.com/gitlab-org/cli.git", branch: "trunk"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b259c365e6cc17761f54499c5d2e69822ff6ef9d9e6749f1a970e238b96b54ff"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b259c365e6cc17761f54499c5d2e69822ff6ef9d9e6749f1a970e238b96b54ff"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b259c365e6cc17761f54499c5d2e69822ff6ef9d9e6749f1a970e238b96b54ff"
    sha256 cellar: :any_skip_relocation, ventura:        "ebeedbe5bbe28dfd229dcda24cdc6474cc59784497b745b86d904e0c41edc60f"
    sha256 cellar: :any_skip_relocation, monterey:       "ebeedbe5bbe28dfd229dcda24cdc6474cc59784497b745b86d904e0c41edc60f"
    sha256 cellar: :any_skip_relocation, big_sur:        "ebeedbe5bbe28dfd229dcda24cdc6474cc59784497b745b86d904e0c41edc60f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e8978018577501848319044677a541f9aa13dbc4533f314062532e5df09b793e"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "1" if OS.mac?

    system "make", "GLAB_VERSION=#{version}"
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
