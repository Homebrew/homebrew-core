class Glab < Formula
  desc "Open-source GitLab command-line tool"
  homepage "https://gitlab.com/gitlab-org/cli"
  url "https://gitlab.com/gitlab-org/cli.git",
    tag:      "v1.58.0",
    revision: "676a7ced34c4b212263e18962ed1a93eeea16ce6"
  license "MIT"
  head "https://gitlab.com/gitlab-org/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9b029a1716fc66394062b88a84a59d9dafbce24d037123f94bff70a6bf460f27"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9b029a1716fc66394062b88a84a59d9dafbce24d037123f94bff70a6bf460f27"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "9b029a1716fc66394062b88a84a59d9dafbce24d037123f94bff70a6bf460f27"
    sha256 cellar: :any_skip_relocation, sonoma:        "d0bebc1fb165244de97c83d67e463880cba18c7c25ab498c8e730f457e224d8a"
    sha256 cellar: :any_skip_relocation, ventura:       "d0bebc1fb165244de97c83d67e463880cba18c7c25ab498c8e730f457e224d8a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "52e43a48ccc4dda14b6067900a862bff9157d5cfe847b41edb0b044eb19700fc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "517d3c76bbe94b1f92249075aca45293be297ddbc97e94faa8670777092c7636"
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
