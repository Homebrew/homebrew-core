class Glab < Formula
  desc "Open-source GitLab command-line tool"
  homepage "https://gitlab.com/gitlab-org/cli"
  url "https://gitlab.com/gitlab-org/cli/-/archive/v1.45.0/cli-v1.45.0.tar.gz"
  sha256 "3cb222f196bb995b87c938e2ac0d496a343515af1530eebff228e630fa243ca9"
  license "MIT"
  head "https://gitlab.com/gitlab-org/cli.git", branch: "trunk"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4e24602b3da12e8aa2750eb7af47907bec2e4dbd17b4166e45a668a81eedbc02"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4a04c6f759221f283232656e1a911b1af7496a5e060825b5c87304d618b03a51"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "eadfb433e0dd810a665a8ce9a30d0f2baac5b7fb03231eb7b5463779674c2930"
    sha256 cellar: :any_skip_relocation, sonoma:         "c0a1e3f0b1caab49e561ef1e83650889015aa25094f23cdde38cc2a3f3b530af"
    sha256 cellar: :any_skip_relocation, ventura:        "57b60573f73d7bab08512ba90d6382c364efc07c8f72ed41ca24e38e7c07a2f6"
    sha256 cellar: :any_skip_relocation, monterey:       "dc4424964d9a1a0fc76cd8384abbffc00194b9ffd6bfc7fac577437b24dcec37"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5fd45bcb7ef92b7c1e1ef23d0be0d10d4b823ec18403eaeb05ca5d614a6bfa96"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "1" if OS.mac?

    system "make", "GLAB_VERSION=v#{version}"
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
