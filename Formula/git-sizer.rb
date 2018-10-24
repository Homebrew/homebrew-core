class GitSizer < Formula
  desc "Compute various size metrics for a Git repository"
  homepage "https://github.com/github/git-sizer"
  url "https://github.com/github/git-sizer/archive/v1.3.0.tar.gz"
  sha256 "c5f77d50eeda704a228f30f5a233ef0e56ef9f4cc83433d46e331b3247d28c6d"

  bottle do
    cellar :any_skip_relocation
    sha256 "4d4e1b47018c1b5efe0ae71996e1dad3f7b0ec4f9616793121463b1c092b03af" => :mojave
    sha256 "add468f96d564f1046a0908cc1f553c73a2ac672973f3c7a7bca47c12fd72867" => :high_sierra
    sha256 "b0a6d0757c623e8e6b1f2ed6e9fb05496b29dd6f615df72e615a7a6a8fb45e3e" => :sierra
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
