class GitSizer < Formula
  desc "Compute various size metrics for a Git repository"
  homepage "https://github.com/github/git-sizer"
  url "https://github.com/github/git-sizer/archive/v1.3.0.tar.gz"
  sha256 "c5f77d50eeda704a228f30f5a233ef0e56ef9f4cc83433d46e331b3247d28c6d"
  license "MIT"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "d0ddd9ed1a43ffcd955e43965bc6f9027c6ac3cc5deed806cdde0d272e54c845"
    sha256 cellar: :any_skip_relocation, big_sur:       "3bbdefc72b5b2eea93256652344b3916fc713367d219bf069e305c552eef9f98"
    sha256 cellar: :any_skip_relocation, catalina:      "0f85f9bd85c765b0a48e5109816ea61a488c5e4cf282a2a9ad1eec3dbc96e31e"
    sha256 cellar: :any_skip_relocation, mojave:        "3ddf790c92b04e46bb005187a8d0020634eba4d46b63afcac06684eac2420b77"
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    ENV["GO111MODULE"] = "auto"
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
