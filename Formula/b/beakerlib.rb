class Beakerlib < Formula
  desc "Shell-level integration testing library"
  homepage "https://github.com/beakerlib/beakerlib"
  url "https://github.com/beakerlib/beakerlib/archive/refs/tags/1.33.4.tar.gz"
  sha256 "b4e1fd4a3ea39923583d9ac70d698b5313306f686020b857963e20b63e444d21"
  license "GPL-2.0-only"
  compatibility_version 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "a69831a8a5a170e2d3a2cb888a40429cacce5dad1caef1eb7040be3bcb0d72e6"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "8a489cceb18ba2a9b035810dd8af210e150915aa11937a1d6efd1a35a75d70c7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "20e1a9475a34b43787d529ce0c846ee8ea928514c2444a4afe0a1911b2febb54"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "158466dad405373a74fe8dda0ea27632949de3dfa721d8e2aaeba81b34b25ea2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "fc257afb53d16d696958b0351c09ffdae5a0ab3314d96d643ea55a18e5d779a5"
  end

  on_macos do
    # Fix `readlink`
    depends_on "coreutils"
    depends_on "gnu-getopt"
  end

  deny_network_access!

  def install
    make_args = [
      "DD=#{prefix}",
    ]
    make_args << "GETOPT_CMD=#{formula_opt_bin("gnu-getopt")}/getopt" if OS.mac?
    make_args << "READLINK_CMD=#{formula_opt_bin("coreutils")}/greadlink" if OS.mac?
    system "make", *make_args, "install"
  end

  test do
    (testpath/"test.sh").write <<~SH
      #!/usr/bin/env bash
      source #{share}/beakerlib/beakerlib.sh || exit 1
      rlJournalStart
        rlPhaseStartTest
          rlPass "All works"
        rlPhaseEnd
      rlJournalEnd
    SH
    expected_journal = /\[\s*PASS\s*\]\s*::\s*All works/
    ENV["BEAKERLIB_DIR"] = testpath
    system "bash", testpath/"test.sh"
    assert_match expected_journal, File.read(testpath/"journal.txt")
    assert_match "TESTRESULT_STATE=complete", File.read(testpath/"TestResults")
    assert_match "TESTRESULT_RESULT_STRING=PASS", File.read(testpath/"TestResults")
  end
end
