class Par2 < Formula
  desc "Parchive: Parity Archive Volume Set for data recovery"
  homepage "https://github.com/Parchive/par2cmdline"
  url "https://github.com/Parchive/par2cmdline/releases/download/v0.8.0/par2cmdline-0.8.0.tar.bz2"
  sha256 "496430e185f2d82e54245a0554341a1826f06c5e673fa12a10f176c7f9b42964"

  bottle do
    cellar :any_skip_relocation
    sha256 "b47768e76669350def4fa99bd4c5f6462a8f73446d7709c00453e1acceab66df" => :mojave
    sha256 "569f6c3227a6e65de30991c3b921e321cb3b5e4e85e341042b2e3fcb00d2685e" => :high_sierra
    sha256 "85ca540e5daeb33c115c6cc37ae2bcb52b4db822679471ccf31598125f475d63" => :sierra
    sha256 "d6e135782c3e4279e2233cba53d5fc62dc6ea3b5c8f0d2c07c653cc66cac2bcd" => :el_capitan
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
