class Bear < Formula
  desc "Generate compilation database for clang tooling"
  homepage "https://github.com/rizsotto/Bear"
  url "https://github.com/rizsotto/Bear/archive/2.2.1.tar.gz"
  mirror "https://mirrors.kernel.org/debian/pool/main/b/bear/bear_2.2.1.orig.tar.gz"
  sha256 "bfe711fae29f173f9d33a7d8c42434a2f40d0247fbb6ff618fdd91c878f76a7b"
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
    mkdir "build" do
      system "cmake", "..", *std_cmake_args
      system "make", "install"
    end
  end

  test do
    system "#{bin}/bear", "true"
    assert File.exist? "compile_commands.json"
  end
end
