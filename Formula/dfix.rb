class Dfix < Formula
  desc "Auto-upgrade tool for D source code"
  homepage "https://github.com/dlang-community/dfix"
  url "https://github.com/dlang-community/dfix.git",
      :tag      => "v0.3.5",
      :revision => "5265a8db4b0fdc54a3d0837a7ddf520ee94579c4"
  head "https://github.com/dlang-community/dfix.git", :shallow => false

  bottle do
    sha256 "f0e31bef3fb90648a84bd1ba54d87c9d1baff75bc0f6038987f19cfe31a1f610" => :mojave
    sha256 "6469d400a0d8e44247410d3250bb53080e6822747252a68883e2bb9e03aeb282" => :high_sierra
    sha256 "ff44843ec1e5040e1d2313f88610f27d7712f883c6b5f4030f24a9ad14dd4996" => :sierra
    sha256 "dff56042492f091f6877bbb452608cebb3571dbf9302cd411a63222671507838" => :el_capitan
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
