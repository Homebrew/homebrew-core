class Glab < Formula
  desc "Open-source GitLab command-line tool"
  homepage "https://gitlab.com/gitlab-org/cli"
  url "https://gitlab.com/gitlab-org/cli.git",
    tag:      "v1.81.0",
    revision: "01fd7984c91ff91b54646a16cb4f571d6164911e"
  license "MIT"
  head "https://gitlab.com/gitlab-org/cli.git", branch: "main"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "a653ec9ea6b890cda84b913233ac5cbf51220c6f97a632bce413511af84361d2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a653ec9ea6b890cda84b913233ac5cbf51220c6f97a632bce413511af84361d2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a653ec9ea6b890cda84b913233ac5cbf51220c6f97a632bce413511af84361d2"
    sha256 cellar: :any_skip_relocation, sonoma:        "7e57fb769af135b5e8ffd292ac21b2004dff14324e0da2dc9d57e5b781d39f64"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "202032a86717583553ebf8c4d46fd2065e02e336a1510cb76f840d66625721da"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8826f21a2b207d15d4d228878066123b0aca7b4c7f7a071f8f9d265bc6c58073"
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
