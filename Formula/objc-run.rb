class ObjcRun < Formula
  desc "Use Objective-C files for shell script-like tasks"
  homepage "https://github.com/iljaiwas/objc-run"
  url "https://github.com/iljaiwas/objc-run/archive/1.4.tar.gz"
  sha256 "6d02a31764c457c4a6a9f5df0963d733d611ba873fc32672151ee02a05acd6f2"
  license "MIT"
  head "https://github.com/iljaiwas/objc-run.git"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "867a4f8909af9d28d6995738b58132965a62302f867cf7de125144eb04af1d3c"
    sha256 cellar: :any_skip_relocation, big_sur:       "65be98ab9f851e2184d33c710a7619e6fd55820f0bbd1ad969c77a3f0755dbeb"
    sha256 cellar: :any_skip_relocation, catalina:      "65be98ab9f851e2184d33c710a7619e6fd55820f0bbd1ad969c77a3f0755dbeb"
    sha256 cellar: :any_skip_relocation, mojave:        "65be98ab9f851e2184d33c710a7619e6fd55820f0bbd1ad969c77a3f0755dbeb"
  end

  def install
    bin.install "objc-run"
    pkgshare.install "examples", "test.bash"
  end

  test do
    cp_r pkgshare, testpath
    system "./objc-run/test.bash"
  end
end
