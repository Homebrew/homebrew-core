class Dfix < Formula
  desc "Auto-upgrade tool for D source code"
  homepage "https://github.com/dlang-community/dfix"
  url "https://github.com/dlang-community/dfix.git",
      :tag => "v0.3.2",
      :revision => "396fd6b26f92f4b20b22163ec12712f19a5942cd"
  head "https://github.com/dlang-community/dfix.git", :shallow => false

  bottle do
    sha256 "bc69197be2687f97b4ce65c1589f4e09c082c5bdb41ee8b51248ffd34ccd0890" => :sierra
    sha256 "ee8da255bb3663a160cc9e2040f594b0e71490feda65c56f213a5912ff99ca36" => :el_capitan
    sha256 "70715e792ec79f8b867bba5547b8f193d1d42fe1c36cb78a553051c7d37e407b" => :yosemite
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
