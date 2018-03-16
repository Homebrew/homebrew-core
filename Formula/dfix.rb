class Dfix < Formula
  desc "Auto-upgrade tool for D source code"
  homepage "https://github.com/dlang-community/dfix"
  url "https://github.com/dlang-community/dfix.git",
      :tag => "v0.3.3",
      :revision => "7475d0d2d8b322ad8734d09e1e6ea4d8edb4b957"
  head "https://github.com/dlang-community/dfix.git", :shallow => false

  bottle do
    sha256 "77c5f989b77e63a53aea939dce24c99c203073eba08c687eb0feb8146ea3d630" => :high_sierra
    sha256 "75570e29a01423b0806c248a1daf6ff6c69681c3c530a34d296604b4663920a9" => :sierra
    sha256 "6dbc07c50bbcd397af748e38fea9bbb63876caba64777ff63ae775764258f70f" => :el_capitan
  end

  depends_on "dmd" => :build

  def install
    system "make"
    system "make", "test"
    bin.install "bin/dfix"
    pkgshare.install "test/testfile_expected.d", "test/testfile_master.d"
  end

  test do
    system "#{bin}/dfix", "--help"

    cp "#{pkgshare}/testfile_master.d", "testfile.d"
    system "#{bin}/dfix", "testfile.d"
    system "diff", "testfile.d", "#{pkgshare}/testfile_expected.d"
    # Make sure that running dfix on the output of dfix changes nothing.
    system "#{bin}/dfix", "testfile.d"
    system "diff", "testfile.d", "#{pkgshare}/testfile_expected.d"
  end
end
