class Fetch < Formula
  desc "Download assets from a commit, branch, or tag of GitHub repositories"
  homepage "https://www.gruntwork.io/"
  url "https://github.com/gruntwork-io/fetch/archive/v0.3.9.tar.gz"
  sha256 "bf9b42e1c71885e56de5f9ceba232d6c46027a45369ce99cccdb14af71cce919"
  license "MIT"

  depends_on "go" => :build

  def install
    system "go", "build", "-ldflags", "-X main.VERSION=v#{version}", *std_go_args
  end

  test do
    assert_match "fetch - fetch makes it easy to download files, folders, and release assets",
    shell_output("#{bin}/fetch --help 2>1&")
  end
end
