class GitSizer < Formula
  desc "Compute various size metrics for a Git repository"
  homepage "https://github.com/github/git-sizer"
  url "https://github.com/github/git-sizer/archive/v1.2.0.tar.gz"
  sha256 "e3d82e2231ba2113eb792fbcff5435ca925d6ffd9eccab8fdeafc3f0ae6fb134"

  bottle do
    cellar :any_skip_relocation
    sha256 "c8a13389e8b39223f79cf27de21f7e108f626ad455a02e3817ec8ed4fe95a8e6" => :mojave
    sha256 "72d013557dd6f12350f6eaf0b392dbae2f6b13dc0b9aa79944647eb0a83ec41e" => :high_sierra
    sha256 "493dc4b2fbd95814967a3b38db9d7b4c989246f22e3ede39b4c08945a2f0939e" => :sierra
    sha256 "ff70d09071d0dc18d576e352c6d2e46a22110ef2dc86c25ad5eb67b679ca6da8" => :el_capitan
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    (buildpath/"src/github.com/github/git-sizer").install buildpath.children
    cd "src/github.com/github/git-sizer" do
      system "go", "build", "-o", bin/"git-sizer"
      prefix.install_metafiles
    end
  end

  test do
    system "git", "init"
    output = shell_output("#{bin}/git-sizer")
    assert_match "No problems above the current threshold were found", output
  end
end
