class Libkeyfinder < Formula
  desc "Musical key detection for digital audio, GPL v3"
  homepage "https://mixxxdj.github.io/libkeyfinder/"
  url "https://github.com/mixxxdj/libkeyfinder/archive/refs/tags/2.2.8.tar.gz"
  sha256 "a54fc6c5ff435bb4b447f175bc97f9081fb5abf0edd5d125e6f5215c8fff4d11"
  license "GPL-3.0-or-later"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "6aea01723afe6eb5a66b410f68f0b6e1e36edf0acc87e5d178faa2ee1e7f1526"
    sha256 cellar: :any,                 arm64_sequoia: "2dd1ceb165b79e82738bf1fa3fa7e21a71f6ed471fd3c0214a96dda2f82f967d"
    sha256 cellar: :any,                 arm64_sonoma:  "02d5e2117d55a2768b021f74dd627f52db228bf54394a60025454903fdeb3f39"
    sha256 cellar: :any,                 arm64_ventura: "400c2779b10b2a10e3d3e06372aec2c37b348ffb352dd214448b07dc488c7cfb"
    sha256 cellar: :any,                 sonoma:        "0d16cad59170872627fa1b08e4cf237e0758205f9ea62499e89a358d5bc012e3"
    sha256 cellar: :any,                 ventura:       "35794d840b7cae4b2dda6e5f9b26854a0572cdf99c08ef2d5d331c8c5928d818"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4c2ce01391bb60dbbadde01920c9ee4d34d9b8e86a894713aba206404c74843c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0b50fcc57a84c874798b361edbf9e5ddbb899108ab57144ad31b1cff6582a736"
  end

  depends_on "cmake" => :build
  depends_on "fftw"

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.cpp").write <<~CPP
      #include <keyfinder/keyfinder.h>
      #include <keyfinder/workspace.h>
      int main(void) {
        KeyFinder::Workspace w;
        w.chromagram = new KeyFinder::Chromagram(1);
        KeyFinder::KeyFinder kf;
        return KeyFinder::SILENCE == kf.keyOfChromagram(w) ? 0 : 1;
      }
    CPP
    system ENV.cxx, "test.cpp", "-std=c++11", "-I#{include}", "-L#{lib}", "-lkeyfinder", "-o", "test"
    system "./test"
  end
end
