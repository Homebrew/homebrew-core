class Bear < Formula
  desc "Generate compilation database for clang tooling"
  homepage "https://github.com/rizsotto/Bear"
  url "https://github.com/rizsotto/Bear/archive/2.3.0.tar.gz"
  sha256 "007eda5e4df17fdacb1c493e1f42cd77f5ef554d30e84a4d31a82608a63f4f2b"
  head "https://github.com/rizsotto/Bear.git"

  bottle do
    cellar :any
    sha256 "3e94a1b7226e68015afdb570f214ca00f2815cfd26b027b7c5e512b42642290b" => :sierra
    sha256 "635e3966b880c02cb91fd53ce90fa1711bb51b94989aa2de08f6d055f5c25f3d" => :el_capitan
    sha256 "3dadf1db08f65a09ba16cfe1246d09262f61115d1cdc1de0371ddafa4b6f6b9c" => :yosemite
  end

  depends_on :python if MacOS.version <= :snow_leopard
  depends_on "cmake" => :build

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end

  test do
    system "#{bin}/bear", "true"
    assert File.exist? "compile_commands.json"
  end
end
