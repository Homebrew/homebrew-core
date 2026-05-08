class Glab < Formula
  desc "Open-source GitLab command-line tool"
  homepage "https://gitlab.com/gitlab-org/cli"
  url "https://gitlab.com/gitlab-org/cli.git",
    tag:      "v1.94.0",
    revision: "aa456f48555068e900b45b0b5451ce27125bef6c"
  license "MIT"
  head "https://gitlab.com/gitlab-org/cli.git", branch: "main"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "db3fc24b268e04972562a35c9cd61e0b02d05be1c5381ac8d13e34bf632dd757"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "db3fc24b268e04972562a35c9cd61e0b02d05be1c5381ac8d13e34bf632dd757"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "db3fc24b268e04972562a35c9cd61e0b02d05be1c5381ac8d13e34bf632dd757"
    sha256 cellar: :any_skip_relocation, sonoma:        "b6ece5a282b9e39649f1eb52d76d1b020a42aca917453c4f8de679a700d8d9a0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cda93c172c5672446c6654684c6479d2532ae0cb39f20506dc87fdf5bafb9759"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "427a00584f7a251dde5f1b149a38cb74033f4c4f0cf970fd44b282926f7f5d09"
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
