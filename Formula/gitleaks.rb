class Gitleaks < Formula
  desc "Audit git repos for secrets"
  homepage "https://github.com/zricethezav/gitleaks"
  url "https://github.com/zricethezav/gitleaks/archive/v6.0.0.tar.gz"
  sha256 "0e0c3c0f73c3fa78e1ca924ff69b1df7b85dc180d4672d27da0c8d1c910f5d0e"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "3e6e9f6d0b69194e8040fd4282104ed79f2e463b20213846e6864bd938ea52eb" => :catalina
    sha256 "4bd15ef5063c1c198e541b4b84542efad68472e6580c02abbe01df0f95d61535" => :mojave
    sha256 "6a39d58473e54e86b4f76971f9f7744b31f3408ef803f9e7a970212c697f98c7" => :high_sierra
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
