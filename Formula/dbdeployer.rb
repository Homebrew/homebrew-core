class Dbdeployer < Formula
  desc "Tool to deploy sandboxed MySQL database servers"
  homepage "https://github.com/datacharmer/dbdeployer"
  url "https://github.com/datacharmer/dbdeployer/archive/v1.70.0.tar.gz"
  sha256 "ad0ff7659e21363132bdc35d72205b723937abcb0b9ffc7623806b3d51b00657"
  license "Apache-2.0"
  head "https://github.com/datacharmer/dbdeployer.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0e2cd38ff5887c62cde30dae13a9326c6e611030e802ce3c590bda2cfca0cad6"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b9158007e2758f5f89a5a235281c509db13a9bf9b2c7626cced2a882775d2c92"
    sha256 cellar: :any_skip_relocation, monterey:       "5b80d2d8c561cb9a9850b6809147ccde5df87106a8bff9f9eb75755cd24a98f2"
    sha256 cellar: :any_skip_relocation, big_sur:        "e3f07a16f5100354f3f41e40d8faed6258e1a1bfabf55320c1df32d652fc7db5"
    sha256 cellar: :any_skip_relocation, catalina:       "a756634c3f57a2add358e072489172961fa5c9d81d8b9592353079b78e93e10f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "51dec91fb634f07d82b4be43e20fdb74a04bd175e7ba8fb7e365aaeb3643c8ea"
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
