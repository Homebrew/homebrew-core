class Dbdeployer < Formula
  desc "Tool to deploy sandboxed MySQL database servers"
  homepage "https://github.com/datacharmer/dbdeployer"
  url "https://github.com/datacharmer/dbdeployer/archive/v1.60.0.tar.gz"
  sha256 "f7aa97d24a6dfd6e486db24b09fc72482fce8c21cbe1ced07e0b63b5f908da04"
  license "Apache-2.0"
  head "https://github.com/datacharmer/dbdeployer.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "8c01239d6368c41369b860d413f90bed667fda48b709f58abc5e33aa9561fb1b"
    sha256 cellar: :any_skip_relocation, big_sur:       "987f418e2bbda24daf4d920aef22a09aef24c202f7d007005ec5c7810c820666"
    sha256 cellar: :any_skip_relocation, catalina:      "7209ee6ca22e01bd6a2526d0069e13dc7918c987d5c3b9925975c5de510face5"
    sha256 cellar: :any_skip_relocation, mojave:        "e787cc9e52baf19755efc5a481d069a208c7fa4c07df84acab393c4582b482d5"
  end

  depends_on "go" => :build

  def install
    on_macos do
      system "./scripts/build.sh", "OSX"
      bin.install "dbdeployer-#{version}.osx" => "dbdeployer"
    end
    on_linux do
      system "./scripts/build.sh", "linux"
      bin.install "dbdeployer-#{version}.linux" => "dbdeployer"
    end
    bash_completion.install "docs/dbdeployer_completion.sh"
  end

  test do
    shell_output("dbdeployer init --skip-shell-completion --skip-tarball-download")
    assert_predicate testpath/"opt/mysql", :exist?
    assert_predicate testpath/"sandboxes", :exist?
  end
end
