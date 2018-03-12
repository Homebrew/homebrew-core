class GitSizer < Formula
  desc "Compute various size metrics for a Git repository"
  homepage "https://github.com/github/git-sizer"
  url "https://github.com/github/git-sizer/archive/v1.1.0.tar.gz"
  sha256 "de3de0b45c5460b1da53717812ef051e45efa14c60ed4def7f27c007c752ebb0"

  bottle do
    cellar :any_skip_relocation
    sha256 "5077977cefe0eda0b379b5aa1afebaeec394ee7b0925460f6d0062fbf35db6a7" => :high_sierra
    sha256 "c9cc6a31b7a683cb7e84492a88bb7ef9a983cca2201263eefb6b3bffe8cfbcc2" => :sierra
    sha256 "4071c7761174477eb9147f95450c9f8d027f8ce344aa227b33419466905056f4" => :el_capitan
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
