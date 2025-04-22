class Glab < Formula
  desc "Open-source GitLab command-line tool"
  homepage "https://gitlab.com/gitlab-org/cli"
  url "https://gitlab.com/gitlab-org/cli.git",
    tag:      "v1.55.0",
    revision: "a806d3d2ae8515ca43be48a83598c04bb71c9328"
  license "MIT"
  head "https://gitlab.com/gitlab-org/cli.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9b6b5824f279ab34257571f72446b4a7e3791330eee4c51795212bf8b621b35d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9b6b5824f279ab34257571f72446b4a7e3791330eee4c51795212bf8b621b35d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "9b6b5824f279ab34257571f72446b4a7e3791330eee4c51795212bf8b621b35d"
    sha256 cellar: :any_skip_relocation, sonoma:        "1b5aa8854792e59353d7242dd82cb4c50a286e7256fc9c76a306a60235c240a7"
    sha256 cellar: :any_skip_relocation, ventura:       "1b5aa8854792e59353d7242dd82cb4c50a286e7256fc9c76a306a60235c240a7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f8dfaaa6cf07974a138ee834ae30ff01edbf8fc4855c97f94a3c8d9ddd01cd53"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "51b3199147b9a1c66b92b330763c377f86c856125ba2ededdc09f5b2c82ac6eb"
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
