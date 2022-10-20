class Dbdeployer < Formula
  desc "Tool to deploy sandboxed MySQL database servers"
  homepage "https://github.com/datacharmer/dbdeployer"
  url "https://github.com/datacharmer/dbdeployer/archive/v1.69.3.tar.gz"
  sha256 "ada3f002731935d9c61fa2831144063acdec4c1d0e4cefddc65ccb4843f885fc"
  license "Apache-2.0"
  head "https://github.com/datacharmer/dbdeployer.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "786abac83d628e3f7dccca1f46b52d038585b340b99bffa07bcd2963e0f66043"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "93c41b8734221d3b556d0e3f6c7520828df629077fc9062f3d7988ec1b04bc0e"
    sha256 cellar: :any_skip_relocation, monterey:       "30bbb065163da51a8e4334893160e17abbb55ecae5d0fba3d1bc3e6fccef1d4b"
    sha256 cellar: :any_skip_relocation, big_sur:        "0f0067cf609d246dcaa2f0a71a78a10caac166210b023a4a3cbb6fa3dfb36a88"
    sha256 cellar: :any_skip_relocation, catalina:       "cc894950fe6316a397d266fcbe81543008696b95991a09f86886957f2f4927a4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "afe68cd1bc4c325c5b4010df392e32661dd560939cad22060ee30ef63b8fec4c"
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
