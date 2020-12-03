class Gitleaks < Formula
  desc "Audit git repos for secrets"
  homepage "https://github.com/zricethezav/gitleaks"
  url "https://github.com/zricethezav/gitleaks/archive/v7.0.1.tar.gz"
  sha256 "4213eb282cc08fc88781d7cd933cdb48449b75a19e8634b5e4e68b035ddaed47"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "e43f6948f4ae8abec3d9f302bee54c06168e7870ac36a8c0996c74022bfd1530" => :big_sur
    sha256 "6e69319b131a8f6fc013b7d57f5ed3274c2fdf9aa83a689d82a6b4e3b6e1add7" => :catalina
    sha256 "1e48fd0cf2efb2c7b03788dc00de395f0f58787b1ae3e517e065cb65fb0900c3" => :mojave
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
