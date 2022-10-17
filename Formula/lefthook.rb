class Lefthook < Formula
  desc "Fast and powerful Git hooks manager for any type of projects"
  homepage "https://github.com/evilmartians/lefthook"
  url "https://github.com/evilmartians/lefthook/archive/refs/tags/v1.1.3.tar.gz"
  sha256 "ba1345c88b1e62931ae0d410dd908ca53c39531459db23c1312f5ffd947316ae"
  license "MIT"
  head "https://github.com/evilmartians/lefthook.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2f666b5c0723bf533c26b477e4fe3c2ef421f4014a478b7ed6c6fe79532a1103"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d6f427632e1031b725e7eba1bc460c83daafe5f9471bdb129765e81ebd6e70b2"
    sha256 cellar: :any_skip_relocation, monterey:       "71ebd4cbfd4d03ec29b36f830b83c1a2c379cf53cdfb1ee5973a4db8fbe80245"
    sha256 cellar: :any_skip_relocation, big_sur:        "e4643a9de4db9a466affe803aa9da674d92e8b9e9e68daba1861b1f96829157d"
    sha256 cellar: :any_skip_relocation, catalina:       "961df647a26e6e25c369c5af6fe0067bc318a2a4b6cc076efa6c55d0ae656090"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "160aadd154060051c5ea1da7a97bce9c6514b2a35c27f19036f845623e4c69ef"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    system "git", "init"
    system bin/"lefthook", "install"

    assert_predicate testpath/"lefthook.yml", :exist?
    assert_match version.to_s, shell_output("#{bin}/lefthook version")
  end
end
