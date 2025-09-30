class Faudio < Formula
  desc "Accuracy-focused XAudio reimplementation for open platforms"
  homepage "https://fna-xna.github.io/"
  url "https://github.com/FNA-XNA/FAudio/archive/refs/tags/25.09.tar.gz"
  sha256 "0d055030959afc8e5b39e6a16ee33eec1f5e4e9c8d8badb8772001b3b45824a2"
  license "Zlib"
  head "https://github.com/FNA-XNA/FAudio.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "ccbfeb2f8d1d7437d798f137521560d83bca8a86497089da6147d01b9916c13c"
    sha256 cellar: :any,                 arm64_sequoia: "64c3b6eddb7edf5c933823ccc8be3bdbb829ca9d0e8e4a291db17cdd763c065a"
    sha256 cellar: :any,                 arm64_sonoma:  "5e478fee9162d97a36258d3a4b20c64bb211e8fb26726445df6c7462951dff3c"
    sha256 cellar: :any,                 arm64_ventura: "2abf13f5129414678a140abdbb969c835fc1dbfa02fffe1a62bbbe778768bc05"
    sha256 cellar: :any,                 sonoma:        "1bc76602a57fdcea674ff167d60b6cbc4670262243c7e14adf1d93dce1e30afb"
    sha256 cellar: :any,                 ventura:       "6329e3b8e0deadd11b79fa5628bdc862757d426fdc165c985cbe2005a18092df"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "24bc791e5b52541c52c1383bff4cc194009f1dc38dd13d312bc0284ffe88e5b0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "de9c73ebfe65581dc33f30e956d06290b961c6d3be4f11d69bbc0e652faa5f18"
  end

  depends_on "cmake" => :build
  depends_on "sdl3"

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <FAudio.h>
      int main(int argc, char const *argv[])
      {
        FAudio *audio;
        return FAudioCreate(&audio, 0, FAUDIO_DEFAULT_PROCESSOR);
      }
    C
    system ENV.cc, "test.c", "-L#{lib}", "-lFAudio", "-o", "test"
    system "./test"
  end
end
