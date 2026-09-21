class Par2 < Formula
  desc "Parchive: Parity Archive Volume Set for data recovery"
  homepage "https://parchive.github.io"
  url "https://github.com/Parchive/par2cmdline/releases/download/v1.4.0/par2cmdline-1.4.0.tar.bz2"
  sha256 "269aff9d49c6a0c0d1c394300d35c36229764588f56faad5850eaf36c7a298dc"
  license "GPL-2.0-or-later"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "48545302a93dd664eca598e1aef2082521c166983de8593ef93a8bcee538207e"
    sha256 cellar: :any, arm64_tahoe:       "5c8bc516cc357df1caf9f727322ab90ed96bfb08ad1c44c3bad1bcd2c0fae9b7"
    sha256 cellar: :any, arm64_sequoia:     "4bbc5a219438f388a9fcc9b9f19d40e8384cf0c29f3bfc080285109c5a96c08f"
    sha256 cellar: :any, arm64_sonoma:      "c30e2e595960b1409af9033cac4b98f6dd0659dc32320bfc7d3a777336fbc945"
    sha256 cellar: :any, arm64_linux:       "088097ba500a499f16f0647a02ed1c5e15be3c39c52a8d5d3e1513834362f72b"
    sha256 cellar: :any, x86_64_linux:      "39d80aa414a39ad6f8ade2cf14cf2d2ea3ec6db48303ad2d54a675435bac2cd7"
  end

  on_macos do
    depends_on "libomp"
  end

  def install
    if OS.mac?
      libomp = Formula["libomp"]
      ENV.append_to_cflags "-Xpreprocessor -fopenmp -I#{libomp.opt_include} -L#{libomp.opt_lib} -lomp"
    end

    system "./configure", *std_configure_args
    system "make", "install"
  end

  test do
    # Protect a file with par2.
    test_file = testpath/"some-file"
    File.write(test_file, "file contents")
    system bin/"par2", "create", test_file

    # "Corrupt" the file by overwriting, then ask par2 to repair it.
    File.write(test_file, "corrupted contents")
    repair_command_output = shell_output("#{bin}/par2 repair #{test_file}")

    # Verify that par2 claimed to repair the file.
    assert_match "1 file(s) exist but are damaged.", repair_command_output
    assert_match "Repair complete.", repair_command_output

    # Verify that par2 actually repaired the file.
    assert_equal "file contents", File.read(test_file)
  end
end
