class Gitleaks < Formula
  desc "Audit git repos for secrets"
  homepage "https://github.com/zricethezav/gitleaks"
  url "https://github.com/zricethezav/gitleaks/archive/v4.0.1.tar.gz"
  sha256 "4bdbfa641afa9b9a55806dbd679add832f1b12f936623da6bba81addda5f7c6b"

  bottle do
    cellar :any_skip_relocation
    sha256 "fb068767fa123ca3fe3fe6d16e9f9201376f84f54a7bd7d1a3d738c411138752" => :catalina
    sha256 "01392bed274c4b6a6a3328607201369ae167679586aa4de236a8acae4fb9e8bd" => :mojave
    sha256 "6a526ed7a3bde12bb58fc8fcae6d980c420fb9049af7426b03d8e1297c211bbf" => :high_sierra
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
