class Dbdeployer < Formula
  desc "Tool to deploy sandboxed MySQL database servers"
  homepage "https://github.com/datacharmer/dbdeployer"
  url "https://github.com/datacharmer/dbdeployer/archive/v1.69.1.tar.gz"
  sha256 "165950a32760a5e0f32f951eaa0c67a6956cb2cea75ac0381c65f39b7e9789c7"
  license "Apache-2.0"
  head "https://github.com/datacharmer/dbdeployer.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6976de8058384a5ca31fc26927c41686a3da4d0180256ba70baab7916ce3c2b3"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0e19707fd9720749daf5fc19d92a52d74f3665f30d5c662433087df4b6904b2e"
    sha256 cellar: :any_skip_relocation, monterey:       "e140949974c93178df3fbed166f1467853bd3dd9d287f5aa9753079ca3909f31"
    sha256 cellar: :any_skip_relocation, big_sur:        "c1afb2d60b7e418a356855b9f8ef306db97729cf336c174c1b72eba18b8adf0d"
    sha256 cellar: :any_skip_relocation, catalina:       "99665abd33ae2a5c4c7c0aca3311f8b27c1aae542dbec7bd13b86759292b5183"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8b36735f2f67cbc4962ba8cfa3d7583ae6ee404249c97c29c6c0fe9414edd4fa"
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
