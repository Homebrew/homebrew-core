class LsLint < Formula
  desc "Extremely fast file and directory name linter"
  homepage "https://ls-lint.org/"
  url "https://github.com/loeffel-io/ls-lint/archive/refs/tags/v2.2.1.tar.gz"
  sha256 "837087e7aef8e23338bff79815852b618d845afb5742f7ce61936647c64bd394"
  license "MIT"
  head "https://github.com/loeffel-io/ls-lint.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "75b4e68fe2f6ff1f0c89159c9ef16740b70ee3d4da3b43283be0e44714fbf6c9"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "75b4e68fe2f6ff1f0c89159c9ef16740b70ee3d4da3b43283be0e44714fbf6c9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "75b4e68fe2f6ff1f0c89159c9ef16740b70ee3d4da3b43283be0e44714fbf6c9"
    sha256 cellar: :any_skip_relocation, sonoma:         "aa35d9eab19b66cfd180868f93de05656d231600e39d7012e2fcdc152d13a086"
    sha256 cellar: :any_skip_relocation, ventura:        "aa35d9eab19b66cfd180868f93de05656d231600e39d7012e2fcdc152d13a086"
    sha256 cellar: :any_skip_relocation, monterey:       "aa35d9eab19b66cfd180868f93de05656d231600e39d7012e2fcdc152d13a086"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "62c79f279bdb493b3e8196394991af71530a7fcaddb0ef23d94ce71e9bedacb0"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.Version=#{version}"), "./cmd/ls_lint"
    pkgshare.install ".ls-lint.yml"
  end

  test do
    output = shell_output("#{bin}/ls-lint -config #{pkgshare}/.ls-lint.yml -workdir #{testpath} 2>&1", 1)
    assert_match "Library failed for rules: snakecase", output

    assert_match version.to_s, shell_output("#{bin}/ls-lint -version")
  end
end
