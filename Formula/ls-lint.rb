class LsLint < Formula
  desc "Extremely fast file and directory name linter"
  homepage "https://ls-lint.org/"
  url "https://github.com/loeffel-io/ls-lint/archive/refs/tags/v2.0.0.tar.gz"
  sha256 "eab9825d11be7662488ac834ca2fac2adeedd868904c5724c05f13780ec744ce"
  license "MIT"
  head "https://github.com/loeffel-io/ls-lint.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "01e7397d278be5b9d956b5e93a58a279ddc1c41c496afd759b3b8f0c6e336613"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "01e7397d278be5b9d956b5e93a58a279ddc1c41c496afd759b3b8f0c6e336613"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "01e7397d278be5b9d956b5e93a58a279ddc1c41c496afd759b3b8f0c6e336613"
    sha256 cellar: :any_skip_relocation, ventura:        "b827045da76c16c11dc99fad2b7ad5f3c3b6caf33a88708dd80f52edc16371c3"
    sha256 cellar: :any_skip_relocation, monterey:       "b827045da76c16c11dc99fad2b7ad5f3c3b6caf33a88708dd80f52edc16371c3"
    sha256 cellar: :any_skip_relocation, big_sur:        "b827045da76c16c11dc99fad2b7ad5f3c3b6caf33a88708dd80f52edc16371c3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "65fe7d5d01f198e714f91e8b743c40b39587c0d9850333380ac888b3afcabc54"
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
