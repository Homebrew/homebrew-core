class Lefthook < Formula
  desc "Fast and powerful Git hooks manager for any type of projects"
  homepage "https://github.com/evilmartians/lefthook"
  url "https://github.com/evilmartians/lefthook/archive/refs/tags/v1.3.3.tar.gz"
  sha256 "c66a7845d4c47485994ae5e0688317fc804c8f3fb6e7cf8d30025ba80b41ccb5"
  license "MIT"
  head "https://github.com/evilmartians/lefthook.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5c0c7c85b418ef7c2f68ad07d595ff3a04e3ceb4ce3dabda391af69042008afc"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5c0c7c85b418ef7c2f68ad07d595ff3a04e3ceb4ce3dabda391af69042008afc"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5c0c7c85b418ef7c2f68ad07d595ff3a04e3ceb4ce3dabda391af69042008afc"
    sha256 cellar: :any_skip_relocation, ventura:        "4a043d78c2de30a0cff5437889fb51ae892b4ec5afc7381a34bf33048f1f2fd9"
    sha256 cellar: :any_skip_relocation, monterey:       "4a043d78c2de30a0cff5437889fb51ae892b4ec5afc7381a34bf33048f1f2fd9"
    sha256 cellar: :any_skip_relocation, big_sur:        "4a043d78c2de30a0cff5437889fb51ae892b4ec5afc7381a34bf33048f1f2fd9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "64b651e45f14c851b7fe65f18afc83225fe20604823092c682092cd09a8a59a7"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")

    generate_completions_from_executable(bin/"lefthook", "completion")
  end

  test do
    system "git", "init"
    system bin/"lefthook", "install"

    assert_predicate testpath/"lefthook.yml", :exist?
    assert_match version.to_s, shell_output("#{bin}/lefthook version")
  end
end
