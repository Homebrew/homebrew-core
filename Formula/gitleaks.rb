class Gitleaks < Formula
  desc "Audit git repos for secrets"
  homepage "https://github.com/zricethezav/gitleaks"
  url "https://github.com/zricethezav/gitleaks/archive/v7.1.1.tar.gz"
  sha256 "6a827ee65d62a3259b9852ddd0a861c326a62ae691154c7c1dcc93cb3873899a"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "99d50ea716a945f2654cfd61fe8f8bb4418f4487fe8904bedd9c9be62a1b526d" => :big_sur
    sha256 "9031bcd81747b74f991373eb97edbb9016d65e52ac891589a4dae72023af8f0c" => :catalina
    sha256 "1f9582f498c46cbc32dafec388498f5c78df39b534c480dcba694ae0ef6f6325" => :mojave
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
