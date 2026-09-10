class Glab < Formula
  desc "Open-source GitLab command-line tool"
  homepage "https://gitlab.com/gitlab-org/cli"
  url "https://gitlab.com/gitlab-org/cli.git",
    tag:      "v1.117.0",
    revision: "44790937bcbf6120698250cc41c9b4fb811c2a03"
  license "MIT"
  head "https://gitlab.com/gitlab-org/cli.git", branch: "main"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ea84252f1ba9171855e816c25f185faecad58cb7dc0fd67f55462047315bc5ea"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ea84252f1ba9171855e816c25f185faecad58cb7dc0fd67f55462047315bc5ea"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ea84252f1ba9171855e816c25f185faecad58cb7dc0fd67f55462047315bc5ea"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "64a6b359e9496c65758e8fa8533bd571c215105deb6a3cb668bcd27c31ec2c53"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7cc504e29a2cdb6980174fbde9a14d7cf074372c77386fc4d44a9b2265a393e3"
  end

  depends_on "go" => :build

  deny_network_access!

  def fetch
    system "go", "mod", "download"
  end

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
