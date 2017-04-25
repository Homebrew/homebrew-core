class Bear < Formula
  desc "Generate compilation database for clang tooling"
  homepage "https://github.com/rizsotto/Bear"
  url "https://github.com/rizsotto/Bear/archive/2.3.3.tar.gz"
  sha256 "020a252510c437a59a238b3326a7cc2c0b9f074c2b5e74402f14fece87342732"
  head "https://github.com/rizsotto/Bear.git"

  bottle do
    cellar :any
    sha256 "cb297f3175a7f3fd386ef6374218e54e4c8eb0c8fe3b9b89af03e9ccf08f6193" => :sierra
    sha256 "b11a35951a19d652b826a8c0597a3ed1f470298c6e9713d6de1252e9e9b40e7e" => :el_capitan
    sha256 "4858a80fbb47dce0fb020db7e1840780ff17fda8fae04fd3db7af6075987d484" => :yosemite
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
