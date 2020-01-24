class Gitleaks < Formula
  desc "Audit git repos for secrets"
  homepage "https://github.com/zricethezav/gitleaks"
  url "https://github.com/zricethezav/gitleaks/archive/v3.2.2.tar.gz"
  sha256 "35734437f206c9452495fe13e5a32012ee418dd58db5355dafacd96ac107e719"

  bottle do
    cellar :any_skip_relocation
    sha256 "58653ddea7d0dfae8eaedbf1094b366f19690139a9407e6b0c1655c2e2e9fb0b" => :catalina
    sha256 "b2a386bbc443c0ea4374d90990d73ebbd694dad79e7f441d0af38d8155cce2f3" => :mojave
    sha256 "d5509492992c376889b0e6aeb7ebc57dad2e535c3682aef28c0136ff77f30835" => :high_sierra
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
