class Beakerlib < Formula
  desc "Shell-level integration testing library"
  homepage "https://github.com/beakerlib/beakerlib"
  url "https://github.com/beakerlib/beakerlib/archive/refs/tags/1.33.tar.gz"
  sha256 "bd77518403ee5ed6c9040d5aa9f6f4f1ed924ce39451c5dfb0bd9214909d8524"
  license "GPL-2.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7ac61b04e304d6ef86acfe3c995f018c1be73694c2d860c3b5161095c57f7a94"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f96d7c00c44d2acb9ba77ceef08f48265065cff3a3e317b9af09f6bd31016fbc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "92b1a5f19c004bf32acd10c746c3dd9c9a199fb7725a4ed5c72a564f4808e526"
    sha256 cellar: :any_skip_relocation, sonoma:        "a39d98a2c53894c995011b8ff90318f8e732112d57892400ff452fea3b02fcec"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "68a4e0b68dabfada4e6af27c782eb53f0b4a1208969cc937f0e0003102a3982e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3c6a67eafa0b9e81d943cd3b6c565bf70ae3ea30674732baec41e2eb8ef8849f"
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
