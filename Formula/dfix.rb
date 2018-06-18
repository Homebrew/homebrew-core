class Dfix < Formula
  desc "Auto-upgrade tool for D source code"
  homepage "https://github.com/dlang-community/dfix"
  url "https://github.com/dlang-community/dfix.git",
      :tag => "v0.3.4",
      :revision => "e726c26fadf0e3fc1cdcd1cdeeae9f1e0f462671"
  head "https://github.com/dlang-community/dfix.git", :shallow => false

  bottle do
    sha256 "0b7f721031ba8a300a2fcd425d1920d6124993fae5ad6af3a79a9e0d882ff475" => :high_sierra
    sha256 "63c88b055983c1f9e5e76a7c4bf349ce5f07adda884356fd25d2af0653b92732" => :sierra
    sha256 "8e82902ec6075a0df5f09d17258f64fbbff88d4449d5704f9d66fbeae9d370b6" => :el_capitan
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
