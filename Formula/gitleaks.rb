class Gitleaks < Formula
  desc "Audit git repos for secrets"
  homepage "https://github.com/zricethezav/gitleaks"
  url "https://github.com/zricethezav/gitleaks/archive/v4.2.0.tar.gz"
  sha256 "92eedd422cdd815014a1811cbd2be3a1b776e0f371a89974a119e0c1cde60d98"

  bottle do
    cellar :any_skip_relocation
    sha256 "088c736cb7f5ebbe568d3ceedd99449dbe746359ca0b541f5ffa6ce557b00f81" => :catalina
    sha256 "a36a6acf16e46b2ce76f4dba192906407bad37b3efd0477e4ee472b3b5991800" => :mojave
    sha256 "7d9f0a346f85d9ee87c74d12b98265a5d294e9b41d2e08a01c6ec4a2997c95b7" => :high_sierra
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
