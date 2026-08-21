class Par2 < Formula
  desc "Parchive: Parity Archive Volume Set for data recovery"
  homepage "https://parchive.github.io"
  url "https://github.com/Parchive/par2cmdline/releases/download/v1.3.0/par2cmdline-1.3.0.tar.bz2"
  sha256 "60fe185b7662004c658f9d17dc03e7422250ec7238329cf93189f2364cd0d560"
  license "GPL-2.0-or-later"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "142587097b2c18881c1424b37520c788533f9802393690f3cd596abb9bf6a57e"
    sha256 cellar: :any, arm64_sequoia: "be335113a77a729235b537b50cbc84ca48620ef1b427638dfe9ea1e9812ae7ef"
    sha256 cellar: :any, arm64_sonoma:  "486cce935354b37b2dbd5c624cca487acea473c7cbfc05e894b58b592eb4c0d3"
    sha256 cellar: :any, sonoma:        "5077c04a9ec756378252611c76bc93731e909a97d0e7491b87f87bc3cc5b1952"
    sha256 cellar: :any, arm64_linux:   "1e06a4452ab190174bb5367e5fb9976702a7b0b5c63b372c1c091062b0f68eca"
    sha256 cellar: :any, x86_64_linux:  "cb4daa17c86e1fd0158d0c7790f151531f562026f2114942f41387b9cc683e29"
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
