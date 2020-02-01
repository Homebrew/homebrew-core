class Gitleaks < Formula
  desc "Audit git repos for secrets"
  homepage "https://github.com/zricethezav/gitleaks"
  url "https://github.com/zricethezav/gitleaks/archive/v3.3.0.tar.gz"
  sha256 "03f3484bc781a6d63486e763f30be421a313893c78b6f84137ea05319cda8c96"

  bottle do
    cellar :any_skip_relocation
    sha256 "6185a5fdfd437544ddac3b6e6f3275e2745138a26e7e06c1d66718574f4da03d" => :catalina
    sha256 "5f6a7908dee8eb4915397783f4698d49c4c094d1d1fdf01dfcb46505e4362de2" => :mojave
    sha256 "bddf3de19485d199251c91c44d671953588a8f1f58d6d1bac2a8cc6a969f4c39" => :high_sierra
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
