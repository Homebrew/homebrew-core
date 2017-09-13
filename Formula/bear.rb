class Bear < Formula
  desc "Generate compilation database for clang tooling"
  homepage "https://github.com/rizsotto/Bear"
  url "https://github.com/rizsotto/Bear/archive/2.3.6.tar.gz"
  sha256 "94ceb407d4058b22563bc26b5a4d0d1d10df83987320e60e455e8a6a5616a75d"
  head "https://github.com/rizsotto/Bear.git"

  bottle do
    cellar :any
    sha256 "8ee60ce86edb4a522572155bed169297ecef7e439cf8324a1ad81389827b52be" => :sierra
    sha256 "5e664e7f47defc3b65cdd3d7f76be4b533d09e1bb83af886b2c7c2a9fa5b201f" => :el_capitan
    sha256 "6bc90a7ff577dcc3a15a6efd9b9fcfa0ae8093cd00afe82c5c51fe2b7e6eb53e" => :yosemite
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
