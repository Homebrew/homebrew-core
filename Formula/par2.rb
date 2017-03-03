class Par2 < Formula
  desc "Parchive: Parity Archive Volume Set for data recovery"
  homepage "https://github.com/Parchive/par2cmdline"
  url "https://github.com/Parchive/par2cmdline/archive/v0.6.14.tar.gz"
  sha256 "2fd831ba924d9f0ecd9242ca45551b6995ede1ed281af79aa30e7490d5596e7a"

  bottle do
    cellar :any_skip_relocation
    sha256 "bf25adffe0240c407aa4cb09dbd00d710687087b9aa62a07ddbeab9f7be3bf2b" => :sierra
    sha256 "0ad074a40f27a29d3cde489eab4f9e74c1f5bf6fa9be3ca116d4d9e123d290d2" => :el_capitan
    sha256 "562c1b75782b0ce231416d4d27c7d9a8bc12b467f307db84102267bdfd355ef3" => :yosemite
    sha256 "9423c0e84f2dbed9f4ab1df4b94551f350c6fdd98c53d13bacb799a77b2a04a5" => :mavericks
    sha256 "367db0a915a8bdaa9de30be2abc6de9e641d8031864df71998efa7d1be7ef53f" => :mountain_lion
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
