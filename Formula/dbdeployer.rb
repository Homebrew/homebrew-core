class Dbdeployer < Formula
  desc "Tool to deploy sandboxed MySQL database servers"
  homepage "https://github.com/datacharmer/dbdeployer"
  url "https://github.com/datacharmer/dbdeployer/archive/v1.65.1.tar.gz"
  sha256 "b4cc8380f09d1e503c65b354d0995add908f2f0a733a4943982f076a9405c235"
  license "Apache-2.0"
  head "https://github.com/datacharmer/dbdeployer.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8406bd84eb80837c95a852cc23e3fbc8ef814e2cc170ae9cf80d9277a334979e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f9a30ff9d8fec7bd60efa736e73ba77704926a3327c80b7897e9c00ffb60f244"
    sha256 cellar: :any_skip_relocation, monterey:       "4302a25af29e40be8a0f181e29bb0f24525cc544f999f01ef6ae95cad507ef48"
    sha256 cellar: :any_skip_relocation, big_sur:        "22f624f2e11a47ca84fcebcca83657275055e3ddff6f0a8d04257efcb0c0fc75"
    sha256 cellar: :any_skip_relocation, catalina:       "4e8314c239e42bf7e4e816a280ca0876e478154b5eccf40990a79359fbe06b68"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f2f820d2d0306eb708a8c8d6070ddcf26308e435d7101048be947251286fce48"
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
