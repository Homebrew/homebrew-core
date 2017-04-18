class Par2 < Formula
  desc "Parchive: Parity Archive Volume Set for data recovery"
  homepage "https://github.com/Parchive/par2cmdline"
  url "https://github.com/Parchive/par2cmdline/archive/v0.7.0.tar.gz"
  sha256 "d877b728d6d3af422904644310980e4da9eba6685960950fd1cd8277c7b63bd5"

  bottle do
    cellar :any_skip_relocation
    sha256 "4d3d75c93b332c3aaf894ac27a45953da106f8fb57e9435c871e7338fb5f5f74" => :sierra
    sha256 "cb5e7cb51ed7a281c2b353ce55006598738cde2fd42493a0f389104b99bcccb8" => :el_capitan
    sha256 "12774bc7430ebd4e281e5478c0930e17aa1f5f92ac1dc7c8baf9c4b5cea59f58" => :yosemite
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
