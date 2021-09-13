class Dbdeployer < Formula
  desc "Tool to deploy sandboxed MySQL database servers"
  homepage "https://github.com/datacharmer/dbdeployer"
  url "https://github.com/datacharmer/dbdeployer/archive/v1.63.0.tar.gz"
  sha256 "8d7f554b6cfae8bae07ede9cf56fdb88ba26d84b450f959b9b9c2f734027d841"
  license "Apache-2.0"
  head "https://github.com/datacharmer/dbdeployer.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "6969c1f05657328981c0d9f2ad69b126143eee62824f78eda9534c5de14273c0"
    sha256 cellar: :any_skip_relocation, big_sur:       "d96b7c9c43b6e46cdb82c43e834056f17ef53807d3d0ad67c109d76a0a158176"
    sha256 cellar: :any_skip_relocation, catalina:      "1a4a6bc0085fe70bf416841a046018c9f7798480b7b59c18e2846ee3d7157161"
    sha256 cellar: :any_skip_relocation, mojave:        "64a865c61c858e1f847bdbdc4640df078a79d7aed8fcf920931b5b133946aa84"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "87887d29a64d2ae1b0aed3675cdf2dcbc506241289d014d18441796bdec05164"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
    bash_completion.install "docs/dbdeployer_completion.sh"
  end

  test do
    shell_output("dbdeployer init --skip-shell-completion --skip-tarball-download")
    assert_predicate testpath/"opt/mysql", :exist?
    assert_predicate testpath/"sandboxes", :exist?
  end
end
