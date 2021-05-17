class Dbdeployer < Formula
  desc "Tool to deploy sandboxed MySQL database servers"
  homepage "https://github.com/datacharmer/dbdeployer"
  url "https://github.com/datacharmer/dbdeployer/archive/v1.61.0.tar.gz"
  sha256 "d42487304280dc508cc9f8ba8c027f1623c33d7db06b2dc742e55146a21c33e2"
  license "Apache-2.0"
  head "https://github.com/datacharmer/dbdeployer.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "c749e26aeab50d9abb649a90bb3303a429efcedb5f863dd3b2c880b4051a7c02"
    sha256 cellar: :any_skip_relocation, big_sur:       "2e1c6058d58af524c2c41befc5f1f13240f427c473467a270aee97e0c8d08d76"
    sha256 cellar: :any_skip_relocation, catalina:      "3870e057b858f77beaab73f15ed720fa44bf80750b7e2b3e7e09989f26259519"
    sha256 cellar: :any_skip_relocation, mojave:        "5f0644a8ac31e580fe5d4f1454331bac41490b5df8d1354c73533607e42296c3"
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
