class Bear < Formula
  desc "Generate compilation database for clang tooling"
  homepage "https://github.com/rizsotto/Bear"
  url "https://github.com/rizsotto/Bear/archive/2.3.6.tar.gz"
  sha256 "94ceb407d4058b22563bc26b5a4d0d1d10df83987320e60e455e8a6a5616a75d"
  head "https://github.com/rizsotto/Bear.git"

  bottle do
    cellar :any
    sha256 "8aa07985195f658febe161fe51f8fe8a884da27e0f4ee9774e3a65a8f347aa35" => :sierra
    sha256 "4bc0902c7f4ec8119127e9f58b9a65a488fe7e2af93261bbcda69f83cfe4999b" => :el_capitan
    sha256 "6b1cc6ae4b3b53ded3bc9f18c489accc61d1755771a1cb84eb0e8fa9b7c1a937" => :yosemite
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
