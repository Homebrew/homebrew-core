class Glab < Formula
  desc "Open-source GitLab command-line tool"
  homepage "https://gitlab.com/gitlab-org/cli"
  url "https://gitlab.com/gitlab-org/cli.git",
    tag:      "v1.62.0",
    revision: "1df2df0d0eb78a74351ca2d963c7b6c0671eda64"
  license "MIT"
  head "https://gitlab.com/gitlab-org/cli.git", branch: "main"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "79de09da8b155cafdc79b50e8d464c35e1d81ed2bf94aecd8a42e906cc348f68"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "79de09da8b155cafdc79b50e8d464c35e1d81ed2bf94aecd8a42e906cc348f68"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "79de09da8b155cafdc79b50e8d464c35e1d81ed2bf94aecd8a42e906cc348f68"
    sha256 cellar: :any_skip_relocation, sonoma:        "5dd7e49da1ff5def1a1443f0af8d161dd36c0b58ab80ff7d7da5a6089375a806"
    sha256 cellar: :any_skip_relocation, ventura:       "5dd7e49da1ff5def1a1443f0af8d161dd36c0b58ab80ff7d7da5a6089375a806"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8e6808007f236eea48dfc9a4e7434eac4e392a47b0901cbdc061e77a4a29fe5f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "df82f964d80e3bb6a2a5f630b3f438777bf2ad9e8316bc1e7f4ec80cb9bad905"
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
