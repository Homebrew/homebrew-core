class Beakerlib < Formula
  desc "Shell-level integration testing library"
  homepage "https://github.com/beakerlib/beakerlib"
  url "https://github.com/beakerlib/beakerlib/archive/refs/tags/1.31.4.tar.gz"
  sha256 "1c1a5a376e71332e350c56f3ac0433d6b7570b4583400ee1e7a4c7d9cdc5f4cd"
  license "GPL-2.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9623f5cfcf093eced2c4e1c3695812ecf0a7db6a3896cdbf255f8b6ba44c3fad"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "09decd75f0914c2e34fbe97963d238a74f079e8d1ef27e82ef2e7ba41da1f9fb"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b6fa04c4d94639a37919652667280c6eb8e85ce78defc76e2af94450fc7ec255"
    sha256 cellar: :any_skip_relocation, sonoma:        "7d3475bfc5406195fc15d3cf9a88f3324ad027efb50f4381799d9c36a86d872f"
    sha256 cellar: :any_skip_relocation, ventura:       "8ed2d0956f6ac062e613ccb3914feff88f125b3dbd8e84caa5955dec414a965f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "35add5b650f5e9beee810810748f3721a2bbdeb5bb7b167b227b8dbbffd74a48"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1e485dc5c3d91552a8fabf34c64dbde80caf20090009b789ded07851dfd6adc2"
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
    system "bash", "#{testpath}/test.sh"
    assert_match expected_journal, File.read(testpath/"journal.txt")
    assert_match "TESTRESULT_STATE=complete", File.read(testpath/"TestResults")
    assert_match "TESTRESULT_RESULT_STRING=PASS", File.read(testpath/"TestResults")
  end
end
