class Dbdeployer < Formula
  desc "Tool to deploy sandboxed MySQL database servers"
  homepage "https://github.com/datacharmer/dbdeployer"
  url "https://github.com/datacharmer/dbdeployer/archive/v1.55.0.tar.gz"
  sha256 "898f8d7d478cca57728b596473a095f082e83b2027d488779846d4e189f4a0aa"
  license "Apache-2.0"
  head "https://github.com/datacharmer/dbdeployer.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "eb02280d7a6ea9575942093e58a47661f549bf582b6f5ccc38e61b889d0aa798" => :catalina
    sha256 "2c2ecedf83ebfa8baa7150915198e127b3f668e2176cec1cf61349cae81df960" => :mojave
    sha256 "c676969502185010865857ed540219f73b73ffcd2bbf476b1357dee96e2396de" => :high_sierra
  end

  depends_on "go" => :build

  def install
    system "./scripts/build.sh", "OSX"
    bin.install "dbdeployer-#{version}.osx" => "dbdeployer"
    bash_completion.install "docs/dbdeployer_completion.sh"
  end

  test do
    shell_output("dbdeployer init --skip-shell-completion --skip-tarball-download")
    assert_predicate testpath/"opt/mysql", :exist?
    assert_predicate testpath/"sandboxes", :exist?
  end
end
