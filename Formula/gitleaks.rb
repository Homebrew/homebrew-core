class Gitleaks < Formula
  desc "Audit git repos for secrets"
  homepage "https://github.com/zricethezav/gitleaks"
  url "https://github.com/zricethezav/gitleaks/archive/v7.2.0.tar.gz"
  sha256 "7909bf2edf90a5c5d9f3d3c03ca940819090a1be7ff81efa1ceb118f704df6f5"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "81dac3f0a1224ea096c5e7a3e3757344e7868dde8df9fc7cb2acb48e9832d9ea" => :big_sur
    sha256 "52bc5dfb79e9dc2f5be7690d0c5a64c2a1b5b08a996f47d24a3c076acf683993" => :catalina
    sha256 "27e26314e4a7fd7766a9113a607a6466e7ab3b4de5bdd761b56a059094c85286" => :mojave
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
