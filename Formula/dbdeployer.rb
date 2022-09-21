class Dbdeployer < Formula
  desc "Tool to deploy sandboxed MySQL database servers"
  homepage "https://github.com/datacharmer/dbdeployer"
  url "https://github.com/datacharmer/dbdeployer/archive/v1.69.2.tar.gz"
  sha256 "f5cab20462fea4b05d3db01930680da26d634d6a85e508583fa3a440522740ea"
  license "Apache-2.0"
  head "https://github.com/datacharmer/dbdeployer.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4f78f872f16e5b79b69ece7ff73eccd7394e1a2cf234a242fa3f753b0028c798"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "781895af0c3ae9e496073f0a69e7d461a9ffffe75a395e8ef99c053315bf17e0"
    sha256 cellar: :any_skip_relocation, monterey:       "5bba9dc7589acd9c6fce3a95537c79cd335a334e763a4ea8a111ad8d424ed313"
    sha256 cellar: :any_skip_relocation, big_sur:        "e0a55f65f4ee4bc4b62d525f933845c9794d4124a974eb0db7df3b0f6c4b9aa8"
    sha256 cellar: :any_skip_relocation, catalina:       "fbde301245fe963d7ef5b9daef6518e4e6fa9e93b17b5ff01135382d66634d17"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f8db6ff5fbad2a4c6bbab877970ed81ea7ed86ade8eed5ec57b3a56ce6b01840"
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
