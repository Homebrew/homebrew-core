class LsLint < Formula
  desc "Extremely fast file and directory name linter"
  homepage "https://ls-lint.org/"
  url "https://github.com/loeffel-io/ls-lint/archive/refs/tags/v2.3.1.tar.gz"
  sha256 "ea6b53fb2bf13055e1cd5eb4aeeddc883044e859a617adebd1802181cdb44b14"
  license "MIT"
  head "https://github.com/loeffel-io/ls-lint.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "06365825df0600e2300aa56c33ab9f3631554110210f5bf4f38e6b28543de96a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "172e96e228cb48828fb773cdf48c36ecbf194ef62334733deddb4ec6bdb7ef4a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "172e96e228cb48828fb773cdf48c36ecbf194ef62334733deddb4ec6bdb7ef4a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "172e96e228cb48828fb773cdf48c36ecbf194ef62334733deddb4ec6bdb7ef4a"
    sha256 cellar: :any_skip_relocation, sonoma:        "4621cde237fbfb8c5dbcab5049a667d6f096e805672641c3951e7ab560e6036f"
    sha256 cellar: :any_skip_relocation, ventura:       "4621cde237fbfb8c5dbcab5049a667d6f096e805672641c3951e7ab560e6036f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7e03ffa79c655f478d360cb192f0290677f4372b5e323f712a13687c87582aea"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "166d12ed28cae04a36a99d4cb75b71092e0aa7e6d7bd109a17556379381412e4"
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
    assert_match "Library failed for `.dir` rules: snakecase", output

    assert_match version.to_s, shell_output("#{bin}/ls-lint -version")
  end
end
