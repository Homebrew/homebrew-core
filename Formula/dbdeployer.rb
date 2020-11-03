class Dbdeployer < Formula
  desc "Tool to deploy sandboxed MySQL database servers"
  homepage "https://github.com/datacharmer/dbdeployer"
  url "https://github.com/datacharmer/dbdeployer/archive/v1.56.0.tar.gz"
  sha256 "2f0a6273a2971df62b783cbdae787c306f59250d9d52ad466242152406d1d006"
  license "Apache-2.0"
  head "https://github.com/datacharmer/dbdeployer.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "fb64fa2235307cde79cbdb62eb0b6bf0ed97da264f791fdb7b8a844194c9d1af" => :catalina
    sha256 "6cea16d3066446b68ba57f5cc8c5505b7dfc637b462a4a151bbab5077dd8f1f3" => :mojave
    sha256 "fb35d80d90b883f8c100bca714d37b7579e296ba5f27d00473cabf5c7c2ab84e" => :high_sierra
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
