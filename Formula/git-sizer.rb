class GitSizer < Formula
  desc "Compute various size metrics for a Git repository"
  homepage "https://github.com/github/git-sizer"
  url "https://github.com/github/git-sizer/archive/v1.1.0.tar.gz"
  sha256 "de3de0b45c5460b1da53717812ef051e45efa14c60ed4def7f27c007c752ebb0"

  bottle do
    cellar :any_skip_relocation
    sha256 "9bd56de9da0a79e699d5eca39b88308b2c2719523e21a2247babd656c0076891" => :high_sierra
    sha256 "8e784e89563871b3a2ec539b1ed7e9c1fdd399c3e215fc91e63b807325ef3349" => :sierra
    sha256 "3163bbe41948a1f232b48bc2df412a00b91e15a45d6d70842929110a4e3b8395" => :el_capitan
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
