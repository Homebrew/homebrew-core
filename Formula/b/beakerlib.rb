class Beakerlib < Formula
  desc "Shell-level integration testing library"
  homepage "https://github.com/beakerlib/beakerlib"
  url "https://github.com/beakerlib/beakerlib/archive/refs/tags/1.31.3.tar.gz"
  sha256 "7a8eeb8d38fbc75f44d05c95c6541d4ce848444daeaebc313d89afd6f04819e0"
  license "GPL-2.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "40cc80b3e2143b17734bf359364df304b939d3dc8c8184e42935728103ed7144"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "02558da90fa20d0b3744d50fbba05dc9df2850018752566aeb34c7e41aeca289"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "be92557094374bc5d99cd99e1c26a9dda6d9c00f9f8527acdc44edcb5d1f7254"
    sha256 cellar: :any_skip_relocation, sonoma:        "714e371e62644e3c12ebd88e7ce8e90f975edb4b7b69d8f8bd66266b306b92f0"
    sha256 cellar: :any_skip_relocation, ventura:       "93ab05940a43bc936929ba5182690b1a4d940f009de856f3d42f29ffc7e1bf39"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "372f24305e0fe37180887775921ab0efa689ec7d8564b1b02698ccea7f1d2618"
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
