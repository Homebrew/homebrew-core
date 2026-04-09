class Par2 < Formula
  desc "Parchive: Parity Archive Volume Set for data recovery"
  homepage "https://github.com/Parchive/par2cmdline"
  url "https://github.com/Parchive/par2cmdline/releases/download/v1.1.1/par2cmdline-1.1.1.tar.bz2"
  sha256 "aa13effa3a27bee2fecf0eb228b631b0323bc2e085c88bbdc7f4518f8fedcee3"
  license "GPL-2.0-or-later"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "a449305e4be7adb1b596244fad50ae6a07fc3658e42add5aae92d0b81a6baa9f"
    sha256 cellar: :any,                 arm64_sequoia: "9275aaa1eb7db8896690c01dba586b4373358195312db5cce0ab8d16361fd70d"
    sha256 cellar: :any,                 arm64_sonoma:  "f27cbf72540996d8baf8e1d4b7ce54fbfd7ebaf567c87914b3411567bc1cf621"
    sha256 cellar: :any,                 sonoma:        "359f789647be0891efa3967ed182ce475990278ab1c63fe3e50bb1b56f33924e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e9c8a87271b664df8703eddb89092cb9c8adc9759b34e7328ad3d090b90d1340"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cecb502688d0f159c4780146b95e2836966519944acf903f33007b92c19bbb48"
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
