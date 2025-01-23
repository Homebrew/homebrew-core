class LsLint < Formula
  desc "Extremely fast file and directory name linter"
  homepage "https://ls-lint.org/"
  url "https://github.com/loeffel-io/ls-lint/archive/refs/tags/v2.2.3.tar.gz"
  sha256 "10a6f03747b0f9c38538a8c54f8ee7e4539dbadae687519e7f5f8a140f55f34e"
  license "MIT"
  head "https://github.com/loeffel-io/ls-lint.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "ee9b23029c3f7b1f97c91df92585dc3fbb99d0a8f6d8dbde7899ec868e65d310"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "8fac9b7885df446f7fcda2415ea0d4839d9792f7ff18a1905b9184bc30552815"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8fac9b7885df446f7fcda2415ea0d4839d9792f7ff18a1905b9184bc30552815"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8fac9b7885df446f7fcda2415ea0d4839d9792f7ff18a1905b9184bc30552815"
    sha256 cellar: :any_skip_relocation, sonoma:         "39d342e5e3693a26bf268d5c552a76ec32a63fa13c7ff4f8aeaa2f999beb3cad"
    sha256 cellar: :any_skip_relocation, ventura:        "39d342e5e3693a26bf268d5c552a76ec32a63fa13c7ff4f8aeaa2f999beb3cad"
    sha256 cellar: :any_skip_relocation, monterey:       "39d342e5e3693a26bf268d5c552a76ec32a63fa13c7ff4f8aeaa2f999beb3cad"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7bf25330c45872e958d5b59bdcaf1b637bd65a6bfe68708c40895c00cb0a64dd"
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
