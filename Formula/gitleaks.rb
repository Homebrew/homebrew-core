class Gitleaks < Formula
  desc "Audit git repos for secrets"
  homepage "https://github.com/zricethezav/gitleaks"
  url "https://github.com/zricethezav/gitleaks/archive/v3.0.2.tar.gz"
  sha256 "ff4e3a2571d4382140a4f1e941b0cd4348016db3adf94e011544a39a82101b04"

  bottle do
    cellar :any_skip_relocation
    sha256 "18e8902a1de1cebbbfeeeb182a63d5923365f9e0d60359d84ab91e39424709d8" => :catalina
    sha256 "01193c6401631b8588f3a7a0437a68d1d85c59fb1407b645aa334ab35b2962d9" => :mojave
    sha256 "a1bc8b21076c57defe04d2ba392df88420adc02074fe6a35f3561d1c2b8fac9a" => :high_sierra
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
