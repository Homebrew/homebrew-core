class Par2 < Formula
  desc "Parchive: Parity Archive Volume Set for data recovery"
  homepage "https://parchive.github.io"
  url "https://github.com/Parchive/par2cmdline/releases/download/v2.0.0/par2cmdline-2.0.0.tar.bz2"
  sha256 "93b8403d6304bcfbfe5bc5a619099496bfe3510c48b73dae6c26127eeaa91cbb"
  license "GPL-2.0-or-later"
  head "https://github.com/Parchive/par2cmdline.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    manifest_sha256 "9432d1e84a579a6629a83b4bfcf7286ba6985fdb60c8d5790e3cf5b163c70b5d"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "9b9d6252add89cda91cb8cf9eac9346edef079c79a1c44d62b413d60af5d4d16"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "93652d2a76d6096ee2ae582e4ec62b052ba0f1a335c02c37ecce282c5fb2dc5c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "0fb11a7b04831ac7dd90ad7fee4281661f9d86ef0bf12caaf3743d3b3b616124"
    sha256 cellar: :any,                 arm64_linux:       "b6535e6a5d924971215a643ee27b10532c0911241c8e6433746c81261cf25abf"
    sha256 cellar: :any,                 x86_64_linux:      "02c908249a4ecdec1c6d65a81cf946ab637eb86835dbf9bc31b120fd8828f886"
  end

  depends_on "cmake" => :build

  deny_network_access!

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    # Protect a file with par2.
    test_file = testpath/"some-file"
    test_file.write "file contents"
    system bin/"par2", "create", test_file

    # "Corrupt" the file by overwriting, then ask par2 to repair it.
    File.write test_file, "corrupted contents"
    repair_command_output = shell_output("#{bin}/par2 repair #{test_file}")

    # Verify that par2 claimed to repair the file.
    assert_match "1 file(s) exist but are damaged.", repair_command_output
    assert_match "Repair complete.", repair_command_output

    # Verify that par2 actually repaired the file.
    assert_equal "file contents", test_file.read
  end
end
