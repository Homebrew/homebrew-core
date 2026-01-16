class Beakerlib < Formula
  desc "Shell-level integration testing library"
  homepage "https://github.com/beakerlib/beakerlib"
  url "https://github.com/beakerlib/beakerlib/archive/refs/tags/1.32.tar.gz"
  sha256 "f0464a18cea43f851aff9097d978acfadfdce1d06c6a71711e0321f5673f8562"
  license "GPL-2.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "dfb14dd13f3fbe949947d2cde00f3648b2089944ebda5a6ea38724a6fc3e7ffe"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7930f77928bcc354722a6bbbf7a911997673ea598e1a7b5ce677a193ff4c8b3f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5e2acba25dbea55066d57c8324d71146c8538c5db5b580ec22d0d37f2b085281"
    sha256 cellar: :any_skip_relocation, sonoma:        "2674f1fe609fac3380ea5edd2055263bfc074221fd8a83bc1bcf8f2cbd69b0f5"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9ad66784a53ce0c9dc5904a8e78e450b79fa68a6ef6347434a736ad64bb119f0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d64495520630e4c1711c3dbf639aed9412c3a2cba6ef188fb1cc5b1ce6e7c352"
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
