class ObjcRun < Formula
  desc "Use Objective-C files for shell script-like tasks"
  homepage "https://github.com/iljaiwas/objc-run"
  url "https://github.com/iljaiwas/objc-run/archive/refs/tags/1.4.tar.gz"
  sha256 "6d02a31764c457c4a6a9f5df0963d733d611ba873fc32672151ee02a05acd6f2"
  license "MIT"
  head "https://github.com/iljaiwas/objc-run.git", branch: "master"

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 3
    sha256 cellar: :any_skip_relocation, all: "50066d41f8749f1c5865836c1ce1e1a89b502357aebcbd1c8c088bd04b9abc79"
  end

  # failed on linux with `-fobjc-arc is not supported on platforms using the legacy runtime`
  depends_on :macos

  def install
    bin.install "objc-run"
    pkgshare.install "examples", "test.bash"
  end

  test do
    cp_r pkgshare, testpath
    system "./objc-run/test.bash"
  end
end
