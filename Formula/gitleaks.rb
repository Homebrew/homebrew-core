class Gitleaks < Formula
  desc "Audit git repos for secrets"
  homepage "https://github.com/zricethezav/gitleaks"
  url "https://github.com/zricethezav/gitleaks/archive/v3.0.3.tar.gz"
  sha256 "fe8cb70edc22b39551f2004465445899e8103940d88ef44f66c056299cc9aa6c"

  bottle do
    cellar :any_skip_relocation
    sha256 "7d4603983dec489d1bb8c060a3c5a4580068bf99c91b6a3660b5033213ddf3a4" => :catalina
    sha256 "1d3e2438a5b0fb4ac4c966dd4208d88e053b5a7e4b81c1982d35afd20003fa83" => :mojave
    sha256 "2eb4523c2e28307f46e88568ac47792cb6d8f01afdb0b43ee7d12161d78b991d" => :high_sierra
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
