class LsLint < Formula
  desc "Extremely fast file and directory name linter"
  homepage "https://ls-lint.org/"
  url "https://github.com/loeffel-io/ls-lint/archive/refs/tags/v2.1.0.tar.gz"
  sha256 "17d694a4d2b69f890d674278eec3858eb659f13572e8ccbabd969865d7faae61"
  license "MIT"
  head "https://github.com/loeffel-io/ls-lint.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f358caebe3529f91e116bf73333a090f109f0c178cf4f123eab0c01926008c02"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f358caebe3529f91e116bf73333a090f109f0c178cf4f123eab0c01926008c02"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f358caebe3529f91e116bf73333a090f109f0c178cf4f123eab0c01926008c02"
    sha256 cellar: :any_skip_relocation, ventura:        "9c20eac4679e059d25f8b206924eef0315d8a2f5e83d892facb60be63de1295d"
    sha256 cellar: :any_skip_relocation, monterey:       "9c20eac4679e059d25f8b206924eef0315d8a2f5e83d892facb60be63de1295d"
    sha256 cellar: :any_skip_relocation, big_sur:        "9c20eac4679e059d25f8b206924eef0315d8a2f5e83d892facb60be63de1295d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bf01a39f3ea0e091fa21654168b5e12102a68fa956be7dd4492ba64c31cb4576"
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
