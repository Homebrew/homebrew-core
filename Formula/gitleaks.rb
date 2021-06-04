class Gitleaks < Formula
  desc "Audit git repos for secrets"
  homepage "https://github.com/zricethezav/gitleaks"
  url "https://github.com/zricethezav/gitleaks/archive/v7.5.0.tar.gz"
  sha256 "9b06dbec9d1bc220630bb85298158d8a54d4be6f068472a0b3a0cc7a89cdfec7"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "6bbdb1d03b712b5646cd6a642df17395cbfa6d3ede59e773fca847eb331a9429"
    sha256 cellar: :any_skip_relocation, big_sur:       "e2b4b0a51b2570e73336ab89d51f40f962a801a663795e73feeb19e90ed54e56"
    sha256 cellar: :any_skip_relocation, catalina:      "22f51a910f778865734a9a4068d9cda3f53beb23cf319cec5fa1c43e1e1f5ed5"
    sha256 cellar: :any_skip_relocation, mojave:        "b1686d4627cf6a2ca03a00b92584a5289120ddc20a8be31c72e4a8c548e7a432"
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
