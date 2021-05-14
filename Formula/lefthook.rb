class Lefthook < Formula
  desc "Fast and powerful Git hooks manager for any type of projects"
  homepage "https://github.com/evilmartians/lefthook"
  url "https://github.com/evilmartians/lefthook/archive/refs/tags/v0.7.5.tar.gz"
  sha256 "168f3b59acbbf161e46993bc6c48cbf7ba7690030c2202f5f2ea16646da3dc2c"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "c6ed1732fdb56b182d83b1a4972f62be7a3d6f202cb7740e8b2e6b053127eaed"
    sha256 cellar: :any_skip_relocation, big_sur:       "f98449b55a8dc41ad16371e7fd85b24d9fbc46387fa3c245463316e50206a32a"
    sha256 cellar: :any_skip_relocation, catalina:      "732fd05a4e458e2eecfcd75bf51be493a9b4539cc3a2c61736e61d67029bf139"
    sha256 cellar: :any_skip_relocation, mojave:        "85f85f6ac4ad8335f9483e010301eae52ad1b1e26271a6ac76f8e99e8d5e3ac6"
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
