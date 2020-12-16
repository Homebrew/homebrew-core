class Dbdeployer < Formula
  desc "Tool to deploy sandboxed MySQL database servers"
  homepage "https://github.com/datacharmer/dbdeployer"
  url "https://github.com/datacharmer/dbdeployer/archive/v1.58.0.tar.gz"
  sha256 "a73473db5fe8a8ef0fe6f2d791ecad3dfd7f1f331ab0ddffe20ff20187892093"
  license "Apache-2.0"
  head "https://github.com/datacharmer/dbdeployer.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "5043c477646836ffd7de406d7df9f3e9f86e2232977cc55f1a017c4f5008df2b" => :big_sur
    sha256 "3fdeaef9fdfbb94691c536174bd8c2eab50f1aa39b7e338e6e87d170800abb6c" => :catalina
    sha256 "8cf62628751ee37aa674caac618790f8fc1276cff2fadb0b2adceb71e58bd43c" => :mojave
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
