class Glab < Formula
  desc "Open-source GitLab command-line tool"
  homepage "https://gitlab.com/gitlab-org/cli"
  url "https://gitlab.com/gitlab-org/cli.git",
    tag:      "v1.90.0",
    revision: "19936043f5660ccf8e5d54ca5ea4defb084fc5dc"
  license "MIT"
  head "https://gitlab.com/gitlab-org/cli.git", branch: "main"

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "094d6b715258c17724fa5223f350ef8f94d4134ee81bf927e7f8c97c6157dcf4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "094d6b715258c17724fa5223f350ef8f94d4134ee81bf927e7f8c97c6157dcf4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "094d6b715258c17724fa5223f350ef8f94d4134ee81bf927e7f8c97c6157dcf4"
    sha256 cellar: :any_skip_relocation, sonoma:        "5e0bb90ef416e7ba20694c3619c886eacf010ce148b3a5334e1537317022163b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9d94762c5dd9daaad4cf885402ae7a4df6d4472933881d09ef82d74617ce505c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "50b247cddcd375ee55a400997df5c5eb5928ca3baa852b78e8d90bec357c411c"
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
