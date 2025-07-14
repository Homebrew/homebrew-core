class Libre < Formula
  desc "Toolkit library for asynchronous network I/O with protocol stacks"
  homepage "https://github.com/baresip/re"
  url "https://github.com/baresip/re/archive/refs/tags/v3.24.0.tar.gz"
  sha256 "35cfe2cbb52095645334426b17585c080f3457fc1784eed173e54dd1eee41b76"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "f9ba11220e558071ed3904fe10c3f85073d6dba1161585e154ab3e7eebf71325"
    sha256 cellar: :any,                 arm64_sonoma:  "1de3980e87c9be1c3d50a614c1117384b6e53ab5eeef9678e1721ef2a247c7cc"
    sha256 cellar: :any,                 arm64_ventura: "03a49e8f9fdb1d888bef87fd146e93ad6731edf678627373f6d38d0fe56798c3"
    sha256 cellar: :any,                 sonoma:        "2074cbea3d5d024e568a06e4517f9461951f0287cb125304f70ce85598c84584"
    sha256 cellar: :any,                 ventura:       "e3bc949ba71aed571102a8c676826d232c26de10ef9152d99913c337efc14775"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ceb9527595cc46586b5f8f851ee5e95ca3ef7f0366c9a082abf02a53539cf125"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "04cd0693c27367ca16aa924c1872519e5fafffb6add97e425a1ff8f2e7831ace"
  end

  depends_on "cmake" => :build
  depends_on "openssl@3"

  uses_from_macos "zlib"

  def install
    system "cmake", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <stdint.h>
      #include <re/re.h>
      int main() {
        return libre_init();
      }
    C
    system ENV.cc, "-I#{include}", "-I#{include}/re", "test.c", "-L#{lib}", "-lre"
  end
end
