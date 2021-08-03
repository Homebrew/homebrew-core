class Atomicparsley < Formula
  desc "MPEG-4 command-line tool"
  homepage "https://github.com/wez/atomicparsley"
  url "https://github.com/wez/atomicparsley/archive/20210715.151551.e7ad03a.tar.gz"
  version "20210715.151551.e7ad03a"
  sha256 "546dcb5f3b625aff4f6bf22d27a0a636d15854fd729402a6933d31f3d0417e0d"
  license "GPL-2.0-or-later"
  version_scheme 1
  head "https://github.com/wez/atomicparsley.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "1f9c50e5dee5eb4d340f8b6832317f5198b2c5fdcc5b71edf76361a32e009dd2"
    sha256 cellar: :any_skip_relocation, big_sur:       "fbc58b5b09449e0bbf23d23fa3d9d15a1022afaa851833edfba6dbfcf07cb8aa"
    sha256 cellar: :any_skip_relocation, catalina:      "741669e14e97f59e4a44603b19cd1c7d624eae96f4d8a93903dfb7cfc9a00502"
    sha256 cellar: :any_skip_relocation, mojave:        "5e8bdbb474c090d4bf96f02ca4a40a3d3b74acb7e846d58dc90386ba8a740e18"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0666521fbcc67cdad491c444240def7e569f221bbb2d1bcfb359dbb1514fb16f"
  end

  depends_on "cmake" => :build

  uses_from_macos "zlib"

  on_linux do
    depends_on "gcc" => :build
  end

  fails_with gcc: "5"

  def install
    system "cmake", ".", *std_cmake_args
    system "cmake", "--build", ".", "--config", "Release"
    bin.install "AtomicParsley"
  end

  test do
    cp test_fixtures("test.m4a"), testpath/"file.m4a"
    system "#{bin}/AtomicParsley", testpath/"file.m4a", "--artist", "Homebrew", "--overWrite"
    output = shell_output("#{bin}/AtomicParsley file.m4a --textdata")
    assert_match "Homebrew", output
  end
end
