class Gitleaks < Formula
  desc "Audit git repos for secrets"
  homepage "https://github.com/zricethezav/gitleaks"
  url "https://github.com/zricethezav/gitleaks/archive/v6.1.0.tar.gz"
  sha256 "5b38829329711504ec485199eea113a77fb3686bb0b587beb341ea67026d4872"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "4c04665e118eb50c000bb2eda8381bb44248d59a945737f42ab39aae4d673dfe" => :catalina
    sha256 "8009ec61e01284c93fe069ffed4653aeaab05cf3f04e53693e7149c2de77b7fa" => :mojave
    sha256 "60f419dde1e2732c7412bb5e85851dac6fb1f563e6a6fd2fd7ddfc0bb15ac48c" => :high_sierra
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
