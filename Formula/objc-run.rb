class ObjcRun < Formula
  desc "Use Objective-C files for shell script-like tasks"
  homepage "https://github.com/iljaiwas/objc-run"
  url "https://github.com/iljaiwas/objc-run/archive/1.4.tar.gz"
  sha256 "6d02a31764c457c4a6a9f5df0963d733d611ba873fc32672151ee02a05acd6f2"
  license "MIT"
  head "https://github.com/iljaiwas/objc-run.git"

  def install
    # Keep bottles uniform before keg-relocation
    inreplace "objc-run", "/usr/local", HOMEBREW_PREFIX
    bin.install "objc-run"
    pkgshare.install "examples", "test.bash"
  end

  def post_install
    # Undo mistaken keg relocation
    inreplace bin/"objc-run", HOMEBREW_PREFIX, "/usr/local"
  end

  test do
    cp_r pkgshare, testpath
    system "./objc-run/test.bash"
  end
end
