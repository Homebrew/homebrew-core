class Dfix < Formula
  desc "Auto-upgrade tool for D source code"
  homepage "https://github.com/dlang-community/dfix"
  url "https://github.com/dlang-community/dfix.git",
      tag:      "v0.3.5",
      revision: "5265a8db4b0fdc54a3d0837a7ddf520ee94579c4"
  license "BSL-1.0"
  head "https://github.com/dlang-community/dfix.git", shallow: false

  livecheck do
    url "https://code.dlang.org/packages/dfix"
    regex(%r{"badge">v?(\d+(?:\.\d+)+)</strong>}i)
  end

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "bb047ac32131d3ec25b60ca86e77959f7b9625ad469d9e0a1ada3fefe8525d9d" => :big_sur
    sha256 "ff3b76977bcbfb5b7a04bbebb53a794cc522b64987f724fe5f8a8236812eb1f8" => :catalina
    sha256 "24d234e206efa754f8bd900102720280d8efb1af6ec93059a467589acddca3ee" => :mojave
    sha256 "13a2621737c198bd0540f507293a9b015a0ebe36cd3373589a69ec834a863d8d" => :high_sierra
  end

  depends_on "dmd" => :build

  def install
    system "make"
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
