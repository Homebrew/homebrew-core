class Par2 < Formula
  desc "Parchive: Parity Archive Volume Set for data recovery"
  homepage "https://github.com/Parchive/par2cmdline"
  url "https://github.com/Parchive/par2cmdline/releases/download/v0.8.0/par2cmdline-0.8.0.tar.bz2"
  sha256 "496430e185f2d82e54245a0554341a1826f06c5e673fa12a10f176c7f9b42964"

  bottle do
    cellar :any_skip_relocation
    sha256 "a825515ff251975d362998560f5e2e046ce3a9f753be106bbf3717c6d411b7fb" => :high_sierra
    sha256 "6c3432e8a1b7e8ceeabb380af04d13123c9fb542fab7caf62fe8201f3d1adee2" => :sierra
    sha256 "7257b39640dcf1894c2329129406a573b04dd263bf3b06283dc854b5ed17cf8e" => :el_capitan
  end

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    # Protect a file with par2.
    test_file = testpath/"some-file"
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
