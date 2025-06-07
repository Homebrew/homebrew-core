class Glab < Formula
  desc "Open-source GitLab command-line tool"
  homepage "https://gitlab.com/gitlab-org/cli"
  url "https://gitlab.com/gitlab-org/cli.git",
    tag:      "v1.59.2",
    revision: "c0acec3f3bab0b433fabf487e0a71c780680ba90"
  license "MIT"
  head "https://gitlab.com/gitlab-org/cli.git", branch: "main"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ad7782e4ecff87da2537d8ed768e9c4c1a7c9ae994ad204cd4de5e446c43190f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ad7782e4ecff87da2537d8ed768e9c4c1a7c9ae994ad204cd4de5e446c43190f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ad7782e4ecff87da2537d8ed768e9c4c1a7c9ae994ad204cd4de5e446c43190f"
    sha256 cellar: :any_skip_relocation, sonoma:        "e503d618e0f6b78a976f38c29ee9d5537296ca553f996c400d6d731435c1b375"
    sha256 cellar: :any_skip_relocation, ventura:       "e503d618e0f6b78a976f38c29ee9d5537296ca553f996c400d6d731435c1b375"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5683f0f8c93fefb4f94b1c84430fdf3ba76426d275a31dbc34fcf54b885125f3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "25cf63c2340ad641bd9c08f800fa1fe6609de1054a19cbba80eac32e76a4f0b0"
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
