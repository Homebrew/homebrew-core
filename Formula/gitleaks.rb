class Gitleaks < Formula
  desc "Audit git repos for secrets"
  homepage "https://github.com/zricethezav/gitleaks"
  url "https://github.com/zricethezav/gitleaks/archive/v4.3.1.tar.gz"
  sha256 "0a109362ccc1b773407112c8fa81718c09c861fdefdaa19312316aa4f88ef1e0"

  bottle do
    cellar :any_skip_relocation
    sha256 "0914f3304e467de11fabc0033dc36619a43b524cbe343fd50b545dc3a2006f28" => :catalina
    sha256 "862b1ea36f24f6e8e8ca7250ab052456686a780d023ef57705b986cc496ecca0" => :mojave
    sha256 "415fbea9c3ebec2ea657cae7faeb33759ca623784e44ee4a173c6eae5f4d84b1" => :high_sierra
  end

  depends_on "go" => :build

  def install
    system "go", "build", "-ldflags", "-X github.com/zricethezav/gitleaks/version.Version=#{version}",
                 *std_go_args
  end

  test do
    assert_match "remote repository is empty",
      shell_output("#{bin}/gitleaks -r https://github.com/gitleakstest/emptyrepo.git", 2)
  end
end
