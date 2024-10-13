class Beakerlib < Formula
  desc "Shell-level integration testing library"
  homepage "https://github.com/beakerlib/beakerlib"
  url "https://github.com/beakerlib/beakerlib/archive/refs/tags/1.31.2.tar.gz"
  sha256 "2a171c5bf640758eb2c0f177f4f96bdd5badbb05e24b48ed8684dc88f80b6da5"
  license "GPL-2.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "cb52fedd6e9adb89f165f2c0ccae5c7b0d45ce6eb1a586e8ff9a85170736169f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "154c7a897d9ae0a67e8032f0edba8c79d134aa5e666c93d7e77be3b132d63159"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "00c70b79b1effdd9802cb23d852b45006014fdde6bf797febe8a0ae5f03b0d32"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "629e01c6983dd8b122c82e6aa6c78e2079e4dc3e3555a0c166bf64c583125edd"
    sha256 cellar: :any_skip_relocation, sonoma:         "cd38c87e8dd9333398ba6722a0c5c66fd47bc669b148f5cd783a7e559e86144c"
    sha256 cellar: :any_skip_relocation, ventura:        "6018de0a13981367deba8aa3961e20d303f61ffbcead72090f61df9f60b7344c"
    sha256 cellar: :any_skip_relocation, monterey:       "dd51247f5c5a1d8b78742a738658538824ed2d1ed4cf26e8092db84e03643054"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "544a61047282be8469c696245cf6e7018b427676f3cbadf91697f26c0376681f"
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
