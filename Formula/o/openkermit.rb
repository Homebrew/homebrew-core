class Openkermit < Formula
  desc "Scriptable network and serial communication for UNIX and VMS"
  homepage "https://www.openkermit.org/"
  url "https://github.com/openkermit/ckermit/archive/refs/tags/v11.1.518.tar.gz"
  sha256 "25a349adbdd37ce79de003a9f0b1ac16e5a3c61a55e9d03bd6e54df5a2292087"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "ec0af4a57e3c0974157bfd82ccee4a636088efaa335f57cdeb4787c3ae1a6b03"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "cdfebb939cf66e4f66ccf08d832dbf597b3be8cf1e81716633aaa5ac56a33549"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "ef4869f1e6fa8b360ed61b877ecbdf64401e01ad61018a1af6ea4de22e1df9b3"
    sha256 cellar: :any,                 arm64_linux:       "e8e6b00964aff00c0de8b1fafdea111e0578deb1f80c232042c0b304f7ed2264"
    sha256 cellar: :any,                 x86_64_linux:      "3cfaab508f908230294cf6c24a15510bcd5196cb6e0019aee291dc60c423b6a4"
  end

  uses_from_macos "libxcrypt"
  uses_from_macos "ncurses"

  def install
    os = OS.mac? ? "macosx" : "linux"
    system "make", os, "KFLAGS=-DCK_NCURSES -I#{formula_opt_include("ncurses")}"

    man1.mkpath

    # The makefile adds /man to the end of manroot when running install
    # hence we pass share here, not man.  If we don't pass anything it
    # uses {prefix}/man
    system "make", "prefix=#{prefix}", "manroot=#{share}", "install"
  end

  test do
    # /confirm:off keeps this headless.
    system "#{bin}/kermit", "-C",
           "set host /network-type:pseudoterminal \"kermit -x\", get /confirm:off /bin/sh, bye, quit"
    assert_path_exists "sh"
  end
end
