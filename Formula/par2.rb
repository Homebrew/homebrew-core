class Par2 < Formula
  desc "Parchive: Parity Archive Volume Set for data recovery"
  homepage "https://github.com/Parchive/par2cmdline"
  url "https://github.com/Parchive/par2cmdline/archive/v0.7.0.tar.gz"
  sha256 "d877b728d6d3af422904644310980e4da9eba6685960950fd1cd8277c7b63bd5"

  bottle do
    cellar :any_skip_relocation
    sha256 "c682521754ac3c1a98dcf7d83659dcfbba813a0ed0e0d03492e096ec81f7c131" => :sierra
    sha256 "04f53dad3fca869a93bc3bac6e88fea06c0e7d3bb5ab1ca33864d9bbdb0e2e0d" => :el_capitan
    sha256 "b4fa1c1bec1bd003fec831f89b3454c8f24f012688d6100d455d20f1e4f07f36" => :yosemite
  end

  depends_on "automake" => :build
  depends_on "autoconf" => :build

  def install
    system "autoreconf", "-fiv"
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    # Protect a file with par2.
    test_file = "some-file"
    (testpath/test_file).write "file contents"
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
