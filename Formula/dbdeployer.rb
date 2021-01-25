class Dbdeployer < Formula
  desc "Tool to deploy sandboxed MySQL database servers"
  homepage "https://github.com/datacharmer/dbdeployer"
  url "https://github.com/datacharmer/dbdeployer/archive/v1.58.2.tar.gz"
  sha256 "9f60065b64ed163a2f27f3661b9357a1a39cc53678b569c5d831ceb2834fbcb2"
  license "Apache-2.0"
  head "https://github.com/datacharmer/dbdeployer.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "6c946409924946d87108e3e13a0f2bd6529f2b372c62a4427ff0c9c8847a5595" => :big_sur
    sha256 "650546cef526926a0e2185b7f298f09123d6a5391ed7fa6f71314ac5835dea9f" => :arm64_big_sur
    sha256 "c83d5b6fa5b0d36c69c6512e9b2042b877524b0e897583de1ea86130bef40af1" => :catalina
    sha256 "c17f1d8bf41f39d826a0a060d43175909fb106e91c7c5608d67c0602bfe61f6c" => :mojave
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
