class ObjcRun < Formula
  desc "Use Objective-C files for shell script-like tasks"
  homepage "https://github.com/iljaiwas/objc-run"
  url "https://github.com/iljaiwas/objc-run/archive/1.4.tar.gz"
  sha256 "6d02a31764c457c4a6a9f5df0963d733d611ba873fc32672151ee02a05acd6f2"
  license "MIT"
  head "https://github.com/iljaiwas/objc-run.git"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "e779505f8071d158730517e91004a15c2364dbf03acceebd1643e27338792f98"
  end

  pour_bottle? do
    reason "The bottle needs to be installed into #{Homebrew::DEFAULT_PREFIX}."
    # https://github.com/Homebrew/homebrew-core/pull/76633
    # Remove when the following issue is resolved:
    # https://github.com/Homebrew/brew/issues/11302
    satisfy { HOMEBREW_PREFIX.to_s == Homebrew::DEFAULT_PREFIX } unless Hardware::CPU.arm?
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
