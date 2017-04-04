class Par2 < Formula
  desc "Parchive: Parity Archive Volume Set for data recovery"
  homepage "https://github.com/Parchive/par2cmdline"
  url "https://github.com/Parchive/par2cmdline/archive/v0.6.14.tar.gz"
  sha256 "2fd831ba924d9f0ecd9242ca45551b6995ede1ed281af79aa30e7490d5596e7a"

  bottle do
    cellar :any_skip_relocation
    sha256 "c682521754ac3c1a98dcf7d83659dcfbba813a0ed0e0d03492e096ec81f7c131" => :sierra
    sha256 "04f53dad3fca869a93bc3bac6e88fea06c0e7d3bb5ab1ca33864d9bbdb0e2e0d" => :el_capitan
    sha256 "b4fa1c1bec1bd003fec831f89b3454c8f24f012688d6100d455d20f1e4f07f36" => :yosemite
  end

  depends_on "automake" => :build
  depends_on "autoconf" => :build

  # The tests for this version of par2cmdline use the `iflag` option to dd,
  # which doesn't exist in OS X. `iflag` has been removed as of commit
  # 855f3096c9f52cd0fbdb9e237c6c9624f7b90ea6, but no release has been cut since
  # then.
  patch :p1, :DATA

  def install
    system "aclocal"
    system "automake", "--add-missing"
    system "autoconf"
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make", "check"
    system "make", "install"
  end

  test do
    # Protect a file with par2.
    test_file = (testpath/"some-file")
    File.write(test_file, "file contents")
    system "#{bin}/par2", "create", test_file

    # "Corrupt" the file by overwriting, then ask par2 to repair it.
    File.write(test_file, "corrupted contents")
    repair_command_output = shell_output("#{bin}/par2 repair #{test_file}")

    # Verify that par2 claimed to repair the file.
    assert_match "1 file(s) exist but are damaged.", repair_command_output
    assert_match "Repair complete.", repair_command_output

    # Verify that par2 actually repaired the file.
    assert File.read(test_file) == "file contents"
  end
end

__END__
diff --git a/tests/test20 b/tests/test20
index cbedaf3..0a5bf50 100755
--- a/tests/test20
+++ b/tests/test20
@@ -16,7 +16,7 @@ echo $dashes
 echo $banner
 echo $dashes

-dd bs=1000 count=2 iflag=fullblock if=/dev/random of=myfile.dat
+dd bs=1000 count=2 if=/dev/random of=myfile.dat

 banner="Creating PAR 2.0 recovery data"
 dashes=`echo "$banner" | sed s/./-/g`
