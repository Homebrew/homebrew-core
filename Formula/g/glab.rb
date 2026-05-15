class Glab < Formula
  desc "Open-source GitLab command-line tool"
  homepage "https://gitlab.com/gitlab-org/cli"
  url "https://gitlab.com/gitlab-org/cli.git",
    tag:      "v1.97.0",
    revision: "3804f048b9c0df42b793c907d5159352fd86312a"
  license "MIT"
  head "https://gitlab.com/gitlab-org/cli.git", branch: "main"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5524c7eb4aad57ee29f15640111dcdf65ad896c96530cecd8d2479c63d4ee113"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5524c7eb4aad57ee29f15640111dcdf65ad896c96530cecd8d2479c63d4ee113"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5524c7eb4aad57ee29f15640111dcdf65ad896c96530cecd8d2479c63d4ee113"
    sha256 cellar: :any_skip_relocation, sonoma:        "43cad83c71c71d3382ae23e020613916307267d8fd1feba01d60f64d295f9f66"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "021273e4b3352fe88801de74a4faf8c9f9a151b1a1509b22a6a6c1b79c7bebe8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f20747a3b52c4d991186afd7e8e8c87baf960fbf3f34a1dcd847c8055491a32c"
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
