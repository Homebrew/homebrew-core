class Beakerlib < Formula
  desc "Shell-level integration testing library"
  homepage "https://github.com/beakerlib/beakerlib"
  url "https://github.com/beakerlib/beakerlib/archive/refs/tags/1.33.3.tar.gz"
  sha256 "87a054194ddd2e073d50c15b0c4f7cf1373b1a5a82e78d9a8f16f13ade7ee00e"
  license "GPL-2.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ac93e4fadcc6189134beb99c60e92fdc1885d08b7f7c63e96835687b1739d206"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b78f770906898cd4d9510122c1dc2ff241647206680fb158b2f986a8d1f3c236"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "34c3e5cf162dbce8b0b66aa1d01e61fe7e705a3a31f3cf6d8af69443fc913752"
    sha256 cellar: :any_skip_relocation, sonoma:        "fa73a7790a93b61a2d4121817692cfd1be0d471cd9a3451342d74ef0fcd6c2d9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "01657598bcc62619d68864f337989fbbb9cd1788a5e41dc20c8bf0adac80fddc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "298797a26432c9bea16a284a47c43b786c05ab71bd5a9ddbc26415de28b5c3fb"
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
