class Gitleaks < Formula
  desc "Audit git repos for secrets"
  homepage "https://github.com/zricethezav/gitleaks"
  url "https://github.com/zricethezav/gitleaks/archive/v6.1.2.tar.gz"
  sha256 "43d53ed0fa716d47074f4640d1916af0d3dc635a77ce66ebb3167b47b88fb767"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "98c0f659469c1a38dedd53d9748935f365e0a4e108d2ca7e3eab22bd34bb2059" => :catalina
    sha256 "543be8f08244fc11c4a544b641122983f0fa4fc76891a47015dd56d2245a4dbb" => :mojave
    sha256 "841c21bdd898d7e996be93cc9830ccce2c46f40db194a0d443391558539cbcf9" => :high_sierra
  end

  depends_on "go" => :build

  def install
    system "go", "build", "-ldflags", "-X github.com/zricethezav/gitleaks/v#{version.major}/version.Version=#{version}",
                 *std_go_args
  end

  test do
    assert_match "remote repository is empty",
      shell_output("#{bin}/gitleaks -r https://github.com/gitleakstest/emptyrepo.git", 2)
    assert_equal version, shell_output("#{bin}/gitleaks --version")
  end
end
