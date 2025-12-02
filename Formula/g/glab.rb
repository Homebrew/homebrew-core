class Glab < Formula
  desc "Open-source GitLab command-line tool"
  homepage "https://gitlab.com/gitlab-org/cli"
  url "https://gitlab.com/gitlab-org/cli.git",
    tag:      "v1.78.3",
    revision: "b234b22a76748297e303199bb4e381be5dc6572a"
  license "MIT"
  head "https://gitlab.com/gitlab-org/cli.git", branch: "main"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "16438328900481c40fbf3d801c6ae3a4fc26e6a9a6c4ce8fdc0adfa3efb5eb69"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "16438328900481c40fbf3d801c6ae3a4fc26e6a9a6c4ce8fdc0adfa3efb5eb69"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "16438328900481c40fbf3d801c6ae3a4fc26e6a9a6c4ce8fdc0adfa3efb5eb69"
    sha256 cellar: :any_skip_relocation, sonoma:        "31aae886d43cb896fe377f829ee7628364adeaac681a9f3e8819c98cae1d8daa"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "af598641334d740880ea7b2a84dcbf709aa0d7f18a23f8a2ded742c62c36e0cf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ea64702071e93bb146aeb260cd26a56ff3d19067cdf5469cf159dd551a78a2b6"
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
