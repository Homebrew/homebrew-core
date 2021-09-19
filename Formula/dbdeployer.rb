class Dbdeployer < Formula
  desc "Tool to deploy sandboxed MySQL database servers"
  homepage "https://github.com/datacharmer/dbdeployer"
  url "https://github.com/datacharmer/dbdeployer/archive/v1.63.0.tar.gz"
  sha256 "8d7f554b6cfae8bae07ede9cf56fdb88ba26d84b450f959b9b9c2f734027d841"
  license "Apache-2.0"
  head "https://github.com/datacharmer/dbdeployer.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "81054ec0100e4f9c3fcc090b38cef4f54e382b35f3848cf4dfd6c335d759af2c"
    sha256 cellar: :any_skip_relocation, big_sur:       "6f387ef8a00328ad1c0780d7ada85a65a8e2ddef3e6981b5fe01e8ef98c2784f"
    sha256 cellar: :any_skip_relocation, catalina:      "329795cae31ff274e83949dfff8d86b5baa2c58096be8e3b4391b48bb2f1a761"
    sha256 cellar: :any_skip_relocation, mojave:        "22627bf6e9d9f887af5dbfab99e0db38d8d20227a0c900f501c69e00bed1ce18"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "07b7e1f8f8c1b9ddc6501b70039e1fdce0ef5304f63d301a14995c6fb3c3701a"
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
