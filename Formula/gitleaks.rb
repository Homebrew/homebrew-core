class Gitleaks < Formula
  desc "Audit git repos for secrets"
  homepage "https://github.com/zricethezav/gitleaks"
  url "https://github.com/zricethezav/gitleaks/archive/v2.1.0.tar.gz"
  sha256 "b1934928fe31884ec7537b431c6c47a6f1bc744c1357308ff5ae11c624179c88"

  bottle do
    cellar :any_skip_relocation
    sha256 "58d89f7fdf9d48930a1e72043aaaf2d5237c0ba21eb088fb9ec07df7bfdfeede" => :mojave
    sha256 "da870b0d01535b31a7536c62c5d3eaf18a5b096f12ad1fef656a277d53dfbf9d" => :high_sierra
    sha256 "b09751e2fbd8d2d92842c590bde299b2ad49396558c90e2c04d633849adf3c6a" => :sierra
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    ENV["GO111MODULE"] = "on"

    dir = buildpath/"github.com/zricethezav/gitleaks"
    dir.install buildpath.children

    cd dir do
      system "go", "build", "-o", bin/"gitleaks"
      prefix.install_metafiles
    end
  end

  test do
    assert_includes shell_output("#{bin}/gitleaks -r https://github.com/gitleakstest/emptyrepo.git", 2), "remote repository is empty"
  end
end
