class Glab < Formula
  desc "Open-source GitLab command-line tool"
  homepage "https://gitlab.com/gitlab-org/cli"
  url "https://gitlab.com/gitlab-org/cli.git",
    tag:      "v1.109.0",
    revision: "757294c01143360b466a70daf3fbef869fc3a41b"
  license "MIT"
  head "https://gitlab.com/gitlab-org/cli.git", branch: "main"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "261e79f0e4968ce6d1d86bc8f3aedf3514ea3083cc6accbd7090642392ee8656"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "261e79f0e4968ce6d1d86bc8f3aedf3514ea3083cc6accbd7090642392ee8656"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "261e79f0e4968ce6d1d86bc8f3aedf3514ea3083cc6accbd7090642392ee8656"
    sha256 cellar: :any_skip_relocation, sonoma:        "fc20f44f8a6be66d3e197a40dd27473e8883c5e6235118b5d8a345cafe0531ae"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9fce7abccb2b0e61416e4f81b221a258843fc041cd129ff58454b31bb03ddb0c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fdfad6db97680aa464a7e9ac9f77142ac2a7e580c3345930e85b2615c60ad569"
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
