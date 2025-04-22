class Par2 < Formula
  desc "Parchive: Parity Archive Volume Set for data recovery"
  homepage "https://github.com/Parchive/par2cmdline"
  url "https://github.com/Parchive/par2cmdline/releases/download/v0.8.1/par2cmdline-0.8.1.tar.bz2"
  sha256 "5fcd712cae2b73002b0bf450c939b211b3d1037f9bb9c3ae52d6d24a0ba075e4"
  license "GPL-2.0-or-later"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_sequoia: "795991988f29eb7e8df0f57048255c00746b50902eccce965ea17da9408f81ef"
    sha256 cellar: :any,                 arm64_sonoma:  "2f5c0869b28661cea99e5279375b9bdfc8afa2096fcc3581429672b432ce1ca2"
    sha256 cellar: :any,                 arm64_ventura: "f21d77bd344c16d64f1d44f8b309036fb79ef49e1c99cbf9e2247f24047ccb4b"
    sha256 cellar: :any,                 sonoma:        "cfc8a814c3b8ba36172906eaa4154a4c005147fc4ae0f8b337a15c13ac76798e"
    sha256 cellar: :any,                 ventura:       "d15d4e51a0fe805edb56606cca24c5080540e67f310aa768d367f4827f43ddd2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3c646e28b86146698db67de4f9792554f984257c03f95eae86e868f9bf7b5af9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5f150c779b555d4dae48eb29f99551489979909c9db4871ca62c022ec1eb2b6b"
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
