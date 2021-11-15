class Dbdeployer < Formula
  desc "Tool to deploy sandboxed MySQL database servers"
  homepage "https://github.com/datacharmer/dbdeployer"
  url "https://github.com/datacharmer/dbdeployer/archive/v1.63.1.tar.gz"
  sha256 "5cbd7dfaf388bbfdf6da17a261b4dd97c8baaab4fc6b97156e40742012fed8c3"
  license "Apache-2.0"
  head "https://github.com/datacharmer/dbdeployer.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "55d89b01b5062fcf45a99d990f458416d26b1edfb22a509e821203f837d84878"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "de4708588c346992c19f837800415876ec8d496a55b179180dc54ffae1ca7c36"
    sha256 cellar: :any_skip_relocation, monterey:       "80a36f7833c9196bcfc68b6265e5ca45ce8bc4af4fd0dd83a1be93ff0689f140"
    sha256 cellar: :any_skip_relocation, big_sur:        "94c56a683bf5816f8ae3e409736c266cffb4330de3a1d9d8a9a59f58ea78389f"
    sha256 cellar: :any_skip_relocation, catalina:       "5741f942c830b99b3abb96c80177288739917f45cced17ce281eb11b666097fd"
    sha256 cellar: :any_skip_relocation, mojave:         "c8e92e3d5354f34f8e7ae258d58ab6063d9b97e8e69c94f8367c9fd26b051b8e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c58830204b843368e664935c58eb4058a9bdbdca125a3581f80a10635e4b7b4e"
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
