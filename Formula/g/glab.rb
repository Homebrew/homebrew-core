class Glab < Formula
  desc "Open-source GitLab command-line tool"
  homepage "https://gitlab.com/gitlab-org/cli"
  url "https://gitlab.com/gitlab-org/cli.git",
    tag:      "v1.56.0",
    revision: "f8c3a80726456c135219d4a007f09d840dff326e"
  license "MIT"
  head "https://gitlab.com/gitlab-org/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6ee688e6c9cd8b8cd7a60ab82b66466b80d269708b7fc81dd070d79edc541671"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6ee688e6c9cd8b8cd7a60ab82b66466b80d269708b7fc81dd070d79edc541671"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "6ee688e6c9cd8b8cd7a60ab82b66466b80d269708b7fc81dd070d79edc541671"
    sha256 cellar: :any_skip_relocation, sonoma:        "fc70954c6510f1ee211280594009b9991f4aaa0edbbac76af463077d7adc8900"
    sha256 cellar: :any_skip_relocation, ventura:       "fc70954c6510f1ee211280594009b9991f4aaa0edbbac76af463077d7adc8900"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9d4faec4ba154c15075b6c1a40f7dcc27e32824ac4f4598dfbe960e4d22b3eaa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6e07b103f7d4d594af45ca6bd7d4ab4d069df15bc40833d4e6c5af785eedda32"
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
