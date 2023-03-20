class Glab < Formula
  desc "Open-source GitLab command-line tool"
  homepage "https://gitlab.com/gitlab-org/cli"
  url "https://gitlab.com/gitlab-org/cli/-/archive/v1.26.0/cli-v1.26.0.tar.gz"
  sha256 "af1820a7872d53c7119a23317d6c80497374ac9529fc2ab1ea8b1ca033a9b4da"
  license "MIT"
  head "https://gitlab.com/gitlab-org/cli.git", branch: "trunk"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8ab1abd0217f469230ebf751da4aa4a51a02d3df112878e00a3f134b065e53d7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8ab1abd0217f469230ebf751da4aa4a51a02d3df112878e00a3f134b065e53d7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8ab1abd0217f469230ebf751da4aa4a51a02d3df112878e00a3f134b065e53d7"
    sha256 cellar: :any_skip_relocation, ventura:        "25bb0a7e957c10d8d62ec7748f2126fa2ad488baa2de7088b3b80ba2a0c8ecdc"
    sha256 cellar: :any_skip_relocation, monterey:       "25bb0a7e957c10d8d62ec7748f2126fa2ad488baa2de7088b3b80ba2a0c8ecdc"
    sha256 cellar: :any_skip_relocation, big_sur:        "25bb0a7e957c10d8d62ec7748f2126fa2ad488baa2de7088b3b80ba2a0c8ecdc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "36571c353a56a5c62c2444cbc9ef8ee08238cdc4ab42cd8ec9f8fa8c09430b5d"
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
