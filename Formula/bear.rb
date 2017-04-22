class Bear < Formula
  desc "Generate compilation database for clang tooling"
  homepage "https://github.com/rizsotto/Bear"
  url "https://github.com/rizsotto/Bear/archive/2.3.1.tar.gz"
  sha256 "e7e35eb92d5c40b4f2ed3f62fb13e46e190e2379c16d10bbcfeafa27602fd71b"
  head "https://github.com/rizsotto/Bear.git"

  bottle do
    cellar :any
    sha256 "8469250d22acb1e5f048b8950c1458b282161e7ad0244a5d9b007218dc20e2a8" => :sierra
    sha256 "9c43f7f692d9029c65f4a1e46de03e7b6f4d33196d6c8d59a3c48baa2ffc95a7" => :el_capitan
    sha256 "b4c51af5e97b8f8c0626e8ed831d4d01159b26e53464d5141d949f7c04528de3" => :yosemite
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
