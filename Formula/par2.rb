class Par2 < Formula
  desc "Parchive: Parity Archive Volume Set for data recovery"
  homepage "https://github.com/Parchive/par2cmdline"
  url "https://github.com/Parchive/par2cmdline/releases/download/v0.8.1/par2cmdline-0.8.1.tar.bz2"
  sha256 "5fcd712cae2b73002b0bf450c939b211b3d1037f9bb9c3ae52d6d24a0ba075e4"
  license "GPL-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fb4dab9fec0be03e27ff19f97c08170b4603f01c232eb0b75f0f2422e34a9b19"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1a31a28b5aa927f4b5fbf4778e0df5ce27e567cfd1db41f60ad5374c70a7d24b"
    sha256 cellar: :any_skip_relocation, monterey:       "21124f8c1c080a67ee9ad88adbf361163031672a0a7446fead075644628bb56d"
    sha256 cellar: :any_skip_relocation, big_sur:        "8379fe417ad00b81929cef774072179d9f2497156a5b06b706a6cf182d2f93dd"
    sha256 cellar: :any_skip_relocation, catalina:       "26609c45028599a4845f68cda2a5cd08c2a0dc37ae3987d4abf86aed99499f50"
    sha256 cellar: :any_skip_relocation, mojave:         "cded10d8f18c5ab236ceb624854afb672681bd1a86f21e47d70de793db378580"
    sha256 cellar: :any_skip_relocation, high_sierra:    "35477bcfecd91b7fe885739737f576b63545aab51ba997bc60f9a74927b775dc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "68a34f74212b806d82f10515575e8f62a90eb2066d6fffb24c5f422a380854fb"
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
