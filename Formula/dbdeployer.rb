class Dbdeployer < Formula
  desc "Tool to deploy sandboxed MySQL database servers"
  homepage "https://github.com/datacharmer/dbdeployer"
  url "https://github.com/datacharmer/dbdeployer/archive/v1.69.3.tar.gz"
  sha256 "ada3f002731935d9c61fa2831144063acdec4c1d0e4cefddc65ccb4843f885fc"
  license "Apache-2.0"
  head "https://github.com/datacharmer/dbdeployer.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ad650502706f22e4e9343bde30c766b238d2bd5571beda39d5fd6811159e6c19"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6ef7af7e2d12114ba0d93447f75e3abace072df92643799e564c61bb00863560"
    sha256 cellar: :any_skip_relocation, monterey:       "acab4ae9e687cd1cf99fd9ab9f29347c296c3d42c6236995b5382923bbd40b0e"
    sha256 cellar: :any_skip_relocation, big_sur:        "85431418dd88aef55e9239a3e9c391cf9ba724194fec65555cd21e61690201ec"
    sha256 cellar: :any_skip_relocation, catalina:       "5185abdaf31bcc5b2010be1f7d88c1b1b597e70eb6be073685112471672b7737"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5c6038fe7edaac140de910ae6a8725873c4aaa85b18b8373375f7bdd5174e830"
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
