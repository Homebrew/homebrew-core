class Openkermit < Formula
  desc "Scriptable network and serial communication for UNIX and VMS"
  homepage "https://www.openkermit.org/"
  url "https://github.com/openkermit/ckermit/archive/refs/tags/v11.0.509.tar.gz"
  sha256 "628f756a93dc366dd3f51954e11fe6d6d80c00b6f0aace0efc2487f64abe67bf"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "664063edb5f7590c9de44b548d61896e551f775bfae2d4bb808dc2a7548bcfad"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fe3463c097de830c9f0782a95c70ceddbbbcff8d2bc45071cac64692ff528406"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "88c22b6cb44241014f4c2420444884a6369c5322c468b5071442c6bc0211db10"
    sha256 cellar: :any_skip_relocation, sonoma:        "c4d64c74de7fcb26c74b636fc590685a7e365d6f11a9ef2ebb32f3e1df833af7"
    sha256 cellar: :any,                 arm64_linux:   "5e79bcf4c51eeff886789a939bf817881e7db4be5976891fac3dc6a36a3ae8dc"
    sha256 cellar: :any,                 x86_64_linux:  "39423bf1bb25c8ab3a2b506dee36a4263133424a0175ec0f33662bccb79786f8"
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
