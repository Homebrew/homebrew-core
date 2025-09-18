class Par2 < Formula
  desc "Parchive: Parity Archive Volume Set for data recovery"
  homepage "https://github.com/Parchive/par2cmdline"
  url "https://github.com/Parchive/par2cmdline/releases/download/v1.0.0/par2cmdline-1.0.0.tar.bz2"
  sha256 "d4ecfd4b6a6fc28cd5b4685efdb6d305139c755d339313925f8728fab7a37cf2"
  license "GPL-2.0-or-later"

  livecheck do
    url :stable
    strategy :github_latest
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "da1851248ab9cdff094faae097c3cdca735b950851df191f6f8d4f48e17c483b"
    sha256 cellar: :any,                 arm64_sequoia: "5ce70b25e1d26d887fca53fa5ab3269e0e94b8964420fb749ef9ecdb01ec3592"
    sha256 cellar: :any,                 arm64_sonoma:  "263b109002436476cd6f3f1ccf77b1fa7e10562706ba0e5b2dfa2af2538bed64"
    sha256 cellar: :any,                 arm64_ventura: "c413a56ff51e2d96061ec8c346b9f38d0ef4a346e60636928609b1ca5e8ce222"
    sha256 cellar: :any,                 sonoma:        "40eb3c43af4903e8efcdf80dcbf04a864af1b6c5b7d0245d445a54ab525b1605"
    sha256 cellar: :any,                 ventura:       "cd9c7a11d331b367075ec3e767060e8edd71d14b7b56af42431c91d93b38809b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "769bdf5faa546f7ed7b00ac17108839238f549d9a1ec242d7eba95133aadac31"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "699aeaca750dd16232b559e676146c57903adcf96a1cfdf194b19c496fcc22b2"
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
    assert File.read(test_file) == "file contents"
  end
end
