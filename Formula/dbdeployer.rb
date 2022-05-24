class Dbdeployer < Formula
  desc "Tool to deploy sandboxed MySQL database servers"
  homepage "https://github.com/datacharmer/dbdeployer"
  url "https://github.com/datacharmer/dbdeployer/archive/v1.64.0.tar.gz"
  sha256 "8065d2700f870d10e58af7b2764ffa0838254402f874294dbc39845356d6f069"
  license "Apache-2.0"
  head "https://github.com/datacharmer/dbdeployer.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5baa794aac6beb7bbd6483e0c3fab95d0f206f48fa1d787fa7432f2fccc0f759"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8cd8ed8106fafc4e33011ed80782a48a2f11adbdffefe682688f8360bbb614ab"
    sha256 cellar: :any_skip_relocation, monterey:       "a5c34e304a761c7960db63d2822abb6574539cd52d04abdb4b475ff75bd256dc"
    sha256 cellar: :any_skip_relocation, big_sur:        "471b15dfc7d8fde1b0d444713f36e0d4a498f13395c9d6c21469ee0173736a86"
    sha256 cellar: :any_skip_relocation, catalina:       "42bcc1fbcb2e907492b74e4289f25843e86c581aa6fe4f7f4e7d3066c61ee1d5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a75725cf0528b9ee61cc0a9882f4b14fe12fc3bf19040e9178da5a568360a93e"
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
