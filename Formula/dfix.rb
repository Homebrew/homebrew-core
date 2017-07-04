class Dfix < Formula
  desc "Auto-upgrade tool for D source code"
  homepage "https://github.com/dlang-community/dfix"
  url "https://github.com/dlang-community/dfix.git",
      :tag => "v0.3.2",
      :revision => "396fd6b26f92f4b20b22163ec12712f19a5942cd"
  head "https://github.com/dlang-community/dfix.git", :shallow => false

  bottle do
    sha256 "58c2e5ee2f3fe572a0b07797af26de4d44e9194bf65a2eef89cf46d8d2dc7da4" => :sierra
    sha256 "6b19da6a3db617b0dcce69a9c19b6b212e6f64adaacfe0e7296328c74aa8f398" => :el_capitan
    sha256 "28db097fe0facaa42f4b1a441f89237e1ad2480ecb7d81f56dd6937d586e1974" => :yosemite
    sha256 "186aaedeb0b223858a5cb16e133ef03886fe81ece596e376c111342251842c5e" => :mavericks
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
