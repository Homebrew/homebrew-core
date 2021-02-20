class Dbdeployer < Formula
  desc "Tool to deploy sandboxed MySQL database servers"
  homepage "https://github.com/datacharmer/dbdeployer"
  url "https://github.com/datacharmer/dbdeployer/archive/v1.58.2.tar.gz"
  sha256 "9f60065b64ed163a2f27f3661b9357a1a39cc53678b569c5d831ceb2834fbcb2"
  license "Apache-2.0"
  head "https://github.com/datacharmer/dbdeployer.git"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "d990f9abd61b62940623df7242b6eae3504f7b2857acc27fc0054445f600c2d6"
    sha256 cellar: :any_skip_relocation, big_sur:       "97314b16d996ab7c3cc15141f2e3266c8327f1fe23874c954f5f50e0ddcb412b"
    sha256 cellar: :any_skip_relocation, catalina:      "94a7026951d1acb7cf85d970a83a76737445f1789441b6e1ab1c802496e23525"
    sha256 cellar: :any_skip_relocation, mojave:        "a5ac29de3d908479368e4cbb56370cdfbc23d468289c09b86380e21e00f82663"
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
