class CKermit < Formula
  desc "Scriptable network and serial communication for UNIX and VMS"
  homepage "https://www.kermitproject.org/"
  url "https://www.kermitproject.org/ftp/kermit/archives/cku302.tar.gz"
  version "9.0.302"
  sha256 "0d5f2cd12bdab9401b4c836854ebbf241675051875557783c332a6a40dac0711"
  license "BSD-3-Clause"

  # C-Kermit archive file names only contain the patch version and the full
  # version has to be obtained from text on the project page.
  livecheck do
    url "https://www.kermitproject.org/ckermit.html"
    regex(/The current C-Kermit release is v?(\d+(?:\.\d+)+) /i)
  end

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6ee8af35826f4b5be62d1c4b4e8b38eb39915da0b28d6b8f53ff9dfbb99f6698"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8315af8bc632253d0b2fdfde4b9da0fef5ad11af891b4e4eb8b51a35902f1e33"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "259f1f0d2e2a1af6545bec724db3e1f154169dbd33e2b8ef43364381b3664cfe"
    sha256 cellar: :any_skip_relocation, ventura:        "0772fae0e560c8e726c611bd1e5b55d03e77f6f42feb3f763cb12f15a0151dc9"
    sha256 cellar: :any_skip_relocation, monterey:       "e379dd0cdd6eb9eec792cdd48ca7c5b7cd9281288840b15ce1d860fbb78982b2"
    sha256 cellar: :any_skip_relocation, big_sur:        "c2867c176bc81a35f56d5fe29847500b7c5f8c3e05ac10b5986073502a888a0f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0d5959e91d9fce4bee2b835433a8d2cc589f8f9f37e02c0f1078dbe645e6351a"
  end

  uses_from_macos "libxcrypt"
  uses_from_macos "ncurses"

  # Apply patch to fix build failure with glibc 2.28+
  # Will be fixed in next release: https://www.kermitproject.org/ckupdates.html
  patch :DATA

  def install
    os = OS.mac? ? "macosx" : "linux"
    system "make", os
    man1.mkpath

    # The makefile adds /man to the end of manroot when running install
    # hence we pass share here, not man.  If we don't pass anything it
    # uses {prefix}/man
    system "make", "prefix=#{prefix}", "manroot=#{share}", "install"
  end

  test do
    assert_match "C-Kermit #{version}",
                 shell_output("#{bin}/kermit -C VERSION,exit")
  end
end

__END__
diff -ru z/ckucmd.c k/ckucmd.c
--- z/ckucmd.c	2004-01-07 10:04:04.000000000 -0800
+++ k/ckucmd.c	2019-01-01 15:52:44.798864262 -0800
@@ -7103,7 +7103,7 @@
 
 /* Here we must look inside the stdin buffer - highly platform dependent */
 
-#ifdef _IO_file_flags			/* Linux */
+#ifdef _IO_EOF_SEEN			/* Linux */
     x = (int) ((stdin->_IO_read_end) - (stdin->_IO_read_ptr));
     debug(F101,"cmdconchk _IO_file_flags","",x);
 #else  /* _IO_file_flags */
