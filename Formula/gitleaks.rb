class Gitleaks < Formula
  desc "Audit git repos for secrets"
  homepage "https://github.com/zricethezav/gitleaks"
  url "https://github.com/zricethezav/gitleaks/archive/v4.0.1.tar.gz"
  sha256 "4bdbfa641afa9b9a55806dbd679add832f1b12f936623da6bba81addda5f7c6b"

  bottle do
    cellar :any_skip_relocation
    sha256 "a8a7323012977596b53c5a91d9fddf1dd4d91f9ce27b9185613dee84b28af694" => :catalina
    sha256 "035abd17dc37ee30f4831cd9a398f4ee5fef51102093de98071968f4a29b49b1" => :mojave
    sha256 "25379660b730cf8418fc447ecfb99aab8e7c919740afbbe3fb92774f97e44a46" => :high_sierra
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -X github.com/zricethezav/gitleaks/version.Version=#{version}
    ]

    system "go", "build", "-ldflags", ldflags.join(" "), "-o", bin/"gitleaks"
  end

  test do
    assert_includes shell_output("#{bin}/gitleaks -r https://github.com/gitleakstest/emptyrepo.git", 2), "remote repository is empty"
  end
end
