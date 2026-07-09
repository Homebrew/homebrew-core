class Par2 < Formula
  desc "Parchive: Parity Archive Volume Set for data recovery"
  homepage "https://parchive.github.io"
  url "https://github.com/Parchive/par2cmdline/releases/download/v1.2.0/par2cmdline-1.2.0.tar.bz2"
  sha256 "9064bbe14834b51d8c2701e8b5c8b9178a1c2b7fe8345baac0499c86c4fa649c"
  license "GPL-2.0-or-later"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "b03a0f588c447caa805ac52e46b5431915c4b1c3a9a39aa5e03506952dddea2e"
    sha256 cellar: :any, arm64_sequoia: "7e2938b70739f755bd5e45f0acc769e83be547ca74e9b4b97ebf8c7b5c555dba"
    sha256 cellar: :any, arm64_sonoma:  "869c77aef9b3562131d2d56d3f72a43e90ba7abe2369a1a744e6fba22b47f205"
    sha256 cellar: :any, sonoma:        "429261221cf9dd280f3d242cda9872fa4e6645f74c326d01c95b60464e5c9603"
    sha256 cellar: :any, arm64_linux:   "2966e50269074e751f0194d5cd9de1cde917e618ae550d8667785faf9363a7d9"
    sha256 cellar: :any, x86_64_linux:  "c4f7fa104f716fa9837976ca278112543ca4a88c99aa3c9cdf5a829de20a4169"
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
