class Gitleaks < Formula
  desc "Audit git repos for secrets"
  homepage "https://github.com/zricethezav/gitleaks"
  url "https://github.com/zricethezav/gitleaks/archive/v7.1.0.tar.gz"
  sha256 "9cead0631cff82c6a616ad515c7e85e16f7cf97b5d1590cf5db75b5b9bca6998"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "42f1979982c63212f724f97ae22cb59c88040efed7cfff4ebe76a78f3252dd61" => :big_sur
    sha256 "6d7ad52564bd62e9b69b7a12385fc58890a8a060d44cbb200ea5d2d719585f23" => :catalina
    sha256 "f9d255b5943d4ed8435344766cc40558b830e9bd48988bdff71f74c109f0f640" => :mojave
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
