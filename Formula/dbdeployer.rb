class Dbdeployer < Formula
  desc "Tool to deploy sandboxed MySQL database servers"
  homepage "https://github.com/datacharmer/dbdeployer"
  url "https://github.com/datacharmer/dbdeployer/archive/v1.62.0.tar.gz"
  sha256 "a97d91bd319e90122f57b185fa0ba1d64358fa33dab6a859b31bda866ca6cdf8"
  license "Apache-2.0"
  head "https://github.com/datacharmer/dbdeployer.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "2ff4bd841a4cee41b8170cdf3eefe391cace37d1e26440dc1f47e50cdb50b74a"
    sha256 cellar: :any_skip_relocation, big_sur:       "dc524d9108604f78e97ddf188a9b047c93882bebe90c239fed4ab24c007e2308"
    sha256 cellar: :any_skip_relocation, catalina:      "392e65f2085952789fd295b8a0ecc9c1c77a58b841fafa9e2f147c1d0e008086"
    sha256 cellar: :any_skip_relocation, mojave:        "b764ac182e2a6c8019e352b2594f0f58e2ebb40ded97c211b949ac065bd28606"
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
