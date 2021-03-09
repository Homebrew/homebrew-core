class Gitleaks < Formula
  desc "Audit git repos for secrets"
  homepage "https://github.com/zricethezav/gitleaks"
  url "https://github.com/zricethezav/gitleaks/archive/v7.3.0.tar.gz"
  sha256 "10a0d19fef4a3839f8bf3a9d17c3aa728f5378026bca5af944963d0db92c27b5"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "a5bf734f0735cb099e1766cf804286fc88337153d1dc3e735b624b3f6c40a707"
    sha256 cellar: :any_skip_relocation, big_sur:       "bb0b7dffff40b8f273021c853108071c06e2d2538282f088a4a4deeae4c9d533"
    sha256 cellar: :any_skip_relocation, catalina:      "ab96fb1cc07d528418b9af02b8edb303501b4d034e933f81a888dede6fc71338"
    sha256 cellar: :any_skip_relocation, mojave:        "b1d472405693f32f074fb0846eec17118f060f78cd81082b28b5b63c4bccd299"
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
