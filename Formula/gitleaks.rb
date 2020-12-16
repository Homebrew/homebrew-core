class Gitleaks < Formula
  desc "Audit git repos for secrets"
  homepage "https://github.com/zricethezav/gitleaks"
  url "https://github.com/zricethezav/gitleaks/archive/v7.2.0.tar.gz"
  sha256 "7909bf2edf90a5c5d9f3d3c03ca940819090a1be7ff81efa1ceb118f704df6f5"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "aab0bbfe5d3e939cba39a43050c5b6a5ccfc501d3f688cc4d493f830f612726c" => :big_sur
    sha256 "613da0ab2d60ddd4c80dcead4f4942d43056a5a18d88370190865fceaac8f503" => :catalina
    sha256 "92f09149a962293db4244062e475d949db12a2dcdafad909a788c87c693e1f2b" => :mojave
  end

  depends_on "go" => :build

  def install
    system "go", "build", "-ldflags", "-X github.com/zricethezav/gitleaks/v#{version.major}/version.Version=#{version}",
                 *std_go_args
  end

  test do
    output = shell_output("#{bin}/gitleaks -r https://github.com/gitleakstest/emptyrepo.git 2>&1", 1)
    assert_match "level=info msg=\"cloning... https://github.com/gitleakstest/emptyrepo.git\"", output
    assert_match "level=error msg=\"remote repository is empty\"", output

    assert_equal version, shell_output("#{bin}/gitleaks --version")
  end
end
