class Gitleaks < Formula
  desc "Audit git repos for secrets"
  homepage "https://github.com/zricethezav/gitleaks"
  url "https://github.com/zricethezav/gitleaks/archive/v7.0.0.tar.gz"
  sha256 "c55e5a44bd3a70fa2ce19943f348e656cfc83c451d20f6e1d6775545fdf00b6a"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "cb6ab29d2d9beebc5fc37326d389d6078052b4f490960a50e2f3e602a881511a" => :big_sur
    sha256 "038438f9856f5c9e24d5cf22ce5530344d83497bf77436bdb1e8127bdeef138e" => :catalina
    sha256 "4b518371d187541f5fd08e9e9a7749c6e3058b42e1b9f6cd30701741ef5ea531" => :mojave
    sha256 "f7611a12cda9e3fee060612b7818bfe1bf07ce757dadb1f26770607c3e0d5c44" => :high_sierra
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
