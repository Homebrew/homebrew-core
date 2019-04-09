class Gitleaks < Formula
  desc "Audit git repos for secrets"
  homepage "https://github.com/zricethezav/gitleaks"
  url "https://github.com/zricethezav/gitleaks/archive/v1.24.0.tar.gz"
  sha256 "6ba812be47976ca49bc2f5ab888c44ef41b824dd20fa9be5687f4ff6d185c2b1"

  bottle do
    cellar :any_skip_relocation
    sha256 "7a5736f016e74d6a9b2b6b46a76242ba3831291c3a4110fc7e314db18e412ace" => :mojave
    sha256 "7de2efde1f877eb0b23e2a380e59323666e7e5d92d3403eed7492f7f57346eb9" => :high_sierra
    sha256 "3f33e0cef69f8b154fb447986f3add4193f4bb746b31e046a4158fc041f975bb" => :sierra
  end

  depends_on "dep" => :build
  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    ENV["GOBIN"] = bin
    dir = buildpath/"src/github.com/zricethezav/gitleaks"
    dir.install buildpath.children
    cd dir do
      system "dep", "ensure", "-vendor-only"
      system "go", "install"
    end
  end

  test do
    assert_includes shell_output("#{bin}/gitleaks -r https://github.com/gitleakstest/emptyrepo.git"), "0 leaks detected"
  end
end
