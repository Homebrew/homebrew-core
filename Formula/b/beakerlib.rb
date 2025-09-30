class Beakerlib < Formula
  desc "Shell-level integration testing library"
  homepage "https://github.com/beakerlib/beakerlib"
  url "https://github.com/beakerlib/beakerlib/archive/refs/tags/1.31.6.tar.gz"
  sha256 "0f10799eb01625e45bbd84c0bc4fe1dda58c7dc33d207e91898cc56627fffd30"
  license "GPL-2.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "67c41cdb44b346377b71971b913532f6c71c9f5f5bfc3fd6b45f5fc958391880"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9b0aa3088b422da626306b144531c0c4a3d27dfa6007d626528396c26c2c6cc0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ae58c4f636b46fbb6180e2adf0320421a2cee7b164ca7212fd98edc1aa7f44ad"
    sha256 cellar: :any_skip_relocation, sonoma:        "9a35040b3c16fca97747cdc815bf33e5d207e8269bb8a1c7acb9cca010e61735"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c97853218480ad9b6d3432b8310f079ce55a9afc0c0a8e126a139cce9f096d23"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a8d572cdd457970cbeaba48af1bb069d027691913e9a69789ab10d5083aa3f08"
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
