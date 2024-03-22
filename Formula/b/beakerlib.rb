class Beakerlib < Formula
  desc "Shell-level integration testing library"
  homepage "https://github.com/beakerlib/beakerlib"
  url "https://github.com/beakerlib/beakerlib/archive/refs/tags/1.30.tar.gz"
  sha256 "bd06fc61b32d9caf4324587706a8363e37e771355da8297d0c5ba0023ae31098"
  license "GPL-2.0-only"

  on_macos do
    # Fix `readlink`
    depends_on "coreutils"
    depends_on "gnu-getopt"
  end

  def install
    system "make", "DD=#{prefix}", "install"
    (prefix.glob "**/*.sh").each do |f|
      inreplace f, "readlink", "#{Formula["coreutils"].opt_bin}/greadlink", false if OS.mac?
      inreplace f, "getopt", "#{Formula["gnu-getopt"].opt_bin}/getopt", false if OS.mac?
    end
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
