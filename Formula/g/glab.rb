class Glab < Formula
  desc "Open-source GitLab command-line tool"
  homepage "https://gitlab.com/gitlab-org/cli"
  url "https://gitlab.com/gitlab-org/cli/-/archive/v1.55.0/cli-v1.55.0.tar.gz"
  sha256 "21f58698b92035461e8e8ba9040429f4b5a0f6d528d8333834ef522a973384c8"
  license "MIT"
  head "https://gitlab.com/gitlab-org/cli.git", branch: "trunk"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3af9f7cae3c5ee6b52bf3cebbefd581878a1db6656ef6c89cb9cba0a7fc18abe"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3af9f7cae3c5ee6b52bf3cebbefd581878a1db6656ef6c89cb9cba0a7fc18abe"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "3af9f7cae3c5ee6b52bf3cebbefd581878a1db6656ef6c89cb9cba0a7fc18abe"
    sha256 cellar: :any_skip_relocation, sonoma:        "f040a094820c6987351c07170b8a3f7894901745a8b1d4f91ae29c435707037b"
    sha256 cellar: :any_skip_relocation, ventura:       "f040a094820c6987351c07170b8a3f7894901745a8b1d4f91ae29c435707037b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "817dfe7850d9bc63599cf77d674d8d7bd7250b1013e9832ec62c88f27dee442d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f7f31748b2a8a5b224afa5950e2cef5ee61ee2580aa174ed7b55636c7d13b7ba"
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
