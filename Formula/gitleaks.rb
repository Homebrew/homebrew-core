class Gitleaks < Formula
  desc "Audit git repos for secrets"
  homepage "https://github.com/zricethezav/gitleaks"
  url "https://github.com/zricethezav/gitleaks/archive/v7.4.0.tar.gz"
  sha256 "deb23369e5e35f257f86a3cdbadf92a1b24712b1a405932b5e8eb0504c6f580d"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "08385e8eb3897072a4f522d170b5ec8f43546ae52f7b3fa222f32d7f43dac228"
    sha256 cellar: :any_skip_relocation, big_sur:       "14bc654c3ddbd94b7571218d14dfb810ea150d4bf20e195e09e95f3d42b1dcef"
    sha256 cellar: :any_skip_relocation, catalina:      "604a4492ffb2b96ab8ec302688f3c0e4dcdebb2664afde9eee9bc75122cbbca3"
    sha256 cellar: :any_skip_relocation, mojave:        "63a60a21f2b2f729cdbc17c8602c82e9f46a5397384091ce089ed743893f5a05"
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
