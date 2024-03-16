class LsLint < Formula
  desc "Extremely fast file and directory name linter"
  homepage "https://ls-lint.org/"
  url "https://github.com/loeffel-io/ls-lint/archive/refs/tags/v2.2.3.tar.gz"
  sha256 "10a6f03747b0f9c38538a8c54f8ee7e4539dbadae687519e7f5f8a140f55f34e"
  license "MIT"
  head "https://github.com/loeffel-io/ls-lint.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ade0a8aa2afc8d445d935b83d8fb725a8de7811271eafa32a377185d82c8901d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ade0a8aa2afc8d445d935b83d8fb725a8de7811271eafa32a377185d82c8901d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ade0a8aa2afc8d445d935b83d8fb725a8de7811271eafa32a377185d82c8901d"
    sha256 cellar: :any_skip_relocation, sonoma:         "7c3aad50bdfd0fa9ef421b3da5d7ae3bb055892c1ea756af739925d62c557efa"
    sha256 cellar: :any_skip_relocation, ventura:        "7c3aad50bdfd0fa9ef421b3da5d7ae3bb055892c1ea756af739925d62c557efa"
    sha256 cellar: :any_skip_relocation, monterey:       "7c3aad50bdfd0fa9ef421b3da5d7ae3bb055892c1ea756af739925d62c557efa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a4f2eb9dd112354e274be69aa5f364a2e9ea5bc86dff37281f66c4586f3f5115"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.Version=#{version}"), "./cmd/ls_lint"
    pkgshare.install ".ls-lint.yml"
  end

  test do
    (testpath/"Library").mkdir
    touch testpath/"Library/test.py"

    output = shell_output("#{bin}/ls-lint -config #{pkgshare}/.ls-lint.yml -workdir #{testpath} 2>&1", 1)
    assert_match "Library failed for rules: snakecase", output

    assert_match version.to_s, shell_output("#{bin}/ls-lint -version")
  end
end
