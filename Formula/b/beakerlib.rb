class Beakerlib < Formula
  desc "Shell-level integration testing library"
  homepage "https://github.com/beakerlib/beakerlib"
  url "https://github.com/beakerlib/beakerlib/archive/refs/tags/1.30.tar.gz"
  sha256 "9161dd08ca7a9066d2d85ff6911b7c8271fbd6ba76d5fe168f2ad3e705bd2615"
  license "GPL-2.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "11dd0e715e2060438e366eb6bccf7df706aeb3973959083ad3889b6029b0e2cf"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "513d1ad1390fba2d1ef87771c3d0e5b935badfd82039ffea13619b29e4bddb36"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "73e3106075b0e0b2f4fdc78098d3173761423a1c847e44149919ca4ddbceaa4c"
    sha256 cellar: :any_skip_relocation, sonoma:         "ed654c8b1350c49242da1aa3c0be7153c336e34a2efc724857a84a350e8e0b0d"
    sha256 cellar: :any_skip_relocation, ventura:        "7952e38923289e8232557aa25fb7070bb12b148850d99a63ef551f6928b7d0be"
    sha256 cellar: :any_skip_relocation, monterey:       "78a88e0ccdd2d42d1373cf0d086d04f24075cef52b3617933dc38a1ea06f6b37"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1c54757f5688e1f72f09bf489880103e574598e10588a71dca5ec345cc3ec603"
  end

  on_macos do
    # Fix `readlink`
    depends_on "coreutils"
    depends_on "gnu-getopt"
  end

  # Add BSD compatibility. Squash commit of:
  # https://github.com/beakerlib/beakerlib/pull/172
  patch do
    url "https://github.com/LecrisUT/beakerlib/commit/367ccaeb9983752b5c6e93277fd333c29a58e8c2.patch?full_index=1"
    sha256 "e50e098bd1668feb22d27aa604750f222a0df8566ae4887075e2861b760de1b9"
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
    (testpath/"test.sh").write <<~EOS
      #!/usr/bin/env bash
      source #{share}/beakerlib/beakerlib.sh || exit 1
      rlJournalStart
        rlPhaseStartTest
          rlPass "All works"
        rlPhaseEnd
      rlJournalEnd
    EOS
    expected_journal = /\[\s*PASS\s*\]\s*::\s*All works/
    ENV["BEAKERLIB_DIR"] = testpath
    system "bash", "#{testpath}/test.sh"
    assert_match expected_journal, File.read(testpath/"journal.txt")
    assert_match "TESTRESULT_STATE=complete", File.read(testpath/"TestResults")
    assert_match "TESTRESULT_RESULT_STRING=PASS", File.read(testpath/"TestResults")
  end
end
