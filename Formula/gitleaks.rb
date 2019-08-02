class Gitleaks < Formula
  desc "Audit git repos for secrets"
  homepage "https://github.com/zricethezav/gitleaks"
  url "https://github.com/zricethezav/gitleaks/archive/v2.1.0.tar.gz"
  sha256 "b1934928fe31884ec7537b431c6c47a6f1bc744c1357308ff5ae11c624179c88"

  bottle do
    cellar :any_skip_relocation
    sha256 "1ce44002a739b7a76d7787bcbf392b2e615e3b553ddc4d29c38e68d16cd00549" => :mojave
    sha256 "aa7e9017ba5541dfcbead6483e97f813fdbdfa0aae9b453b40e41c62fa03d7b3" => :high_sierra
    sha256 "7543cd36fe58a29d41f12b7a55dfc7bbf4fa31e75051041a50bc430779a435e7" => :sierra
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
