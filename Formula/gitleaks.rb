class Gitleaks < Formula
  desc "Audit git repos for secrets"
  homepage "https://github.com/zricethezav/gitleaks"
  url "https://github.com/zricethezav/gitleaks/archive/v4.3.0.tar.gz"
  sha256 "4ef9eaef76e14123ecb3e55d3d1b11b35faa5e030935f5764f42a18a25edd3df"

  bottle do
    cellar :any_skip_relocation
    sha256 "f9dd70573ef1633c771884181de84fa9980b788014ad89b735a933286e59efa1" => :catalina
    sha256 "11ae2c2ed927193a115cb3a55f20f7ba60474f58b5b43034ce142b02d792b755" => :mojave
    sha256 "7d92cf5cdcced520e59995289d072f8e3ba5722f9a922a56025b5d5fe2fc2048" => :high_sierra
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
