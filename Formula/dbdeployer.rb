class Dbdeployer < Formula
  desc "Tool to deploy sandboxed MySQL database servers"
  homepage "https://github.com/datacharmer/dbdeployer"
  url "https://github.com/datacharmer/dbdeployer/archive/v1.57.0.tar.gz"
  sha256 "c8c84802cffcf3f8ac433c92fc13b75d966321bb8ac89efc4f1142618f896576"
  license "Apache-2.0"
  head "https://github.com/datacharmer/dbdeployer.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "cdf6561ab8357d0e86c01bc6f589f5ac5eac5b0a6e5d9c75e24003f1e8d21429" => :big_sur
    sha256 "1d30b95db8de59f1bdeb25cc5dce634d7b33a4e27f67092e349dc2e468f2c4eb" => :catalina
    sha256 "9aedf4a705ae17ffacf901735f14c9d831b4684588e8cca20e56f34f17407b82" => :mojave
    sha256 "0290db070ad96f26e51a57346a0ea6118d5cfb877eadcda206674bed30dba1fc" => :high_sierra
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
