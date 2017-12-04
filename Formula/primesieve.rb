class Primesieve < Formula
  desc "Fast C/C++ prime number generator"
  homepage "http://primesieve.org/"
  url "https://github.com/kimwalisch/primesieve/archive/v6.3.tar.gz"
  sha256 "d359575d17979c01f19203e61849d1bfea1867de0005e119f15f2f37ae2af83f"

  bottle do
    cellar :any
    sha256 "af3893734990e12ecea5f2137ceddcf0a96464b942c1e35bc9245355ccc1f20c" => :high_sierra
    sha256 "6a4af4c35f124c87885009ee345d2f4d65514ce1441ac443723374913783f1b3" => :sierra
    sha256 "ae3dde00955961cef5c8e46b5f8f7f9c2a9581e9cfc01ea31407d825a4cf0b7c" => :el_capitan
  end

  depends_on "cmake" => :build

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args
      system "make", "install"
    end
  end

  test do
    system "#{bin}/primesieve", "100", "--count", "--print"
  end
end
