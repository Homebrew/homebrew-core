class Gitleaks < Formula
  desc "Audit git repos for secrets"
  homepage "https://github.com/zricethezav/gitleaks"
  url "https://github.com/zricethezav/gitleaks/archive/v7.2.2.tar.gz"
  sha256 "9eaf24ce758903b30c3ebf840ba35020b8dbb3733df9f975dae0bafc650f3fcf"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "92f4ea25d97089e136f0ed5fd5d6e696f2da6e6d90f35cae30cf0047a11daac3"
    sha256 cellar: :any_skip_relocation, big_sur:       "12b782a67f02fdf5544fa5b4fc8ab40243848e40f2254da0f12c9e473aebce7b"
    sha256 cellar: :any_skip_relocation, catalina:      "54f4dcacd3943a063711db03610063b21301122ef57b096a31a4147e547b0f29"
    sha256 cellar: :any_skip_relocation, mojave:        "49f130b583e05eebbf6f980ec606f40360451b38d4f10c1cb98f1f1252d66fbc"
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
