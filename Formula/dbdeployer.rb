class Dbdeployer < Formula
  desc "Tool to deploy sandboxed MySQL database servers"
  homepage "https://github.com/datacharmer/dbdeployer"
  url "https://github.com/datacharmer/dbdeployer/archive/v1.65.1.tar.gz"
  sha256 "b4cc8380f09d1e503c65b354d0995add908f2f0a733a4943982f076a9405c235"
  license "Apache-2.0"
  head "https://github.com/datacharmer/dbdeployer.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4e3fc1ad7266ba70bb3f255862480b47fdfb8a942cb5d73f2a530f6aaeca93eb"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f871daa5be172f367e4f66d59c46fb9b6be82d3521b62156f362c5bfcaf0be85"
    sha256 cellar: :any_skip_relocation, monterey:       "163349b80c9531732f325411b127323ce782d80df76ebd726779fa6d910c940a"
    sha256 cellar: :any_skip_relocation, big_sur:        "9bbd8061b36ac17d944925ee9bf914d36d4ca21c64bf25534d47b43259e9bb95"
    sha256 cellar: :any_skip_relocation, catalina:       "157e551fbd362261225625ec4c516881bc707c64552d1cc8fefdb126d938127a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4d602c749c2a1be11c41091e3dc890fc83978705c74e43f4180848825abbf02e"
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
