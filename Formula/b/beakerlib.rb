class Beakerlib < Formula
  desc "Shell-level integration testing library"
  homepage "https://github.com/beakerlib/beakerlib"
  url "https://github.com/beakerlib/beakerlib/archive/refs/tags/1.33.2.tar.gz"
  sha256 "e13f4df8ad055c05bcca2226d92e298156eb9ea6de81415c844e567e4e7ab117"
  license "GPL-2.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4729c40211eb3f12feaad75e38c1ff947bfcb513005e8cf8e154d3e734f137bc"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5f480c7030f43289613ac3761ef28eb548ce526a788fb3b3da7c462fba5d3a05"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d62cdf165cb1e28665c10d7396f4d3768d46a3d51c8347ed22f00804b0741f9c"
    sha256 cellar: :any_skip_relocation, sonoma:        "6ecddac5a81ead7fcc40956ce114301d9dba6b383022aef8d877656dcc610e53"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "56de7cf183eb5bac857cd3826e4d55773dd4a58d5b697159f5568090fcd58546"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1bb712c0defd08955d01485c42f990c072b076c631d8c5fa2a003973dd110c1b"
  end

  on_macos do
    # Fix `readlink`
    depends_on "coreutils"
    depends_on "gnu-getopt"
  end

  def install
    make_args = [
      "DD=#{prefix}",
    ]
    make_args << "GETOPT_CMD=#{Formula["gnu-getopt"].opt_bin}/getopt" if OS.mac?
    make_args << "READLINK_CMD=#{Formula["coreutils"].opt_bin}/greadlink" if OS.mac?
    system "make", *make_args, "install"
  end

  test do
    (testpath/"test.sh").write <<~SHELL
      #!/usr/bin/env bash
      source #{share}/beakerlib/beakerlib.sh || exit 1
      rlJournalStart
        rlPhaseStartTest
          rlPass "All works"
        rlPhaseEnd
      rlJournalEnd
    SHELL
    expected_journal = /\[\s*PASS\s*\]\s*::\s*All works/
    ENV["BEAKERLIB_DIR"] = testpath
    system "bash", testpath/"test.sh"
    assert_match expected_journal, File.read(testpath/"journal.txt")
    assert_match "TESTRESULT_STATE=complete", File.read(testpath/"TestResults")
    assert_match "TESTRESULT_RESULT_STRING=PASS", File.read(testpath/"TestResults")
  end
end
