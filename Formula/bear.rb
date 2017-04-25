class Bear < Formula
  desc "Generate compilation database for clang tooling"
  homepage "https://github.com/rizsotto/Bear"
  url "https://github.com/rizsotto/Bear/archive/2.3.3.tar.gz"
  sha256 "020a252510c437a59a238b3326a7cc2c0b9f074c2b5e74402f14fece87342732"
  head "https://github.com/rizsotto/Bear.git"

  bottle do
    cellar :any
    sha256 "cc9f03ed93d6fb16d4ec3aa84cd0b4d77abc7d46aba04dda78c0bf555803b2d4" => :sierra
    sha256 "70b922866ee93d1bafccf7b62c156397d848d4d0c5634efd9b0d7789451a26b6" => :el_capitan
    sha256 "c62e64d8fba98b76fd937252dec8b20577355a219052c9ce23be778e9e618c60" => :yosemite
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
