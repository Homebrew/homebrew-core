class Liborigin < Formula
  desc "Library for reading OriginLab OPJ project files"
  homepage "https://sourceforge.net/projects/liborigin/"
  url "https://downloads.sourceforge.net/project/liborigin/liborigin/3.0/liborigin-3.0.4.tar.gz"
  sha256 "b1bf35f72e39892ad351bed4a3e724aee6cfa673281dea2c78cceb9042a74e57"
  license all_of: ["GPL-2.0-or-later", "GPL-3.0-or-later"]

  livecheck do
    url :stable
    regex(%r{url=.*?/liborigin[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "afdc03e25afa56a45df6eb69c71f6d31cb9358de123501b7dc250759378840ac"
    sha256 cellar: :any, arm64_sequoia: "9e07e1fbfd9450d591fdc91a3b4e3fb3a45f5748815565fb88ebae57385c2d79"
    sha256 cellar: :any, arm64_sonoma:  "300d2a04ebaef3eb916ffd573333a6cadaab212a3d8f25762b7c3f39633b451d"
    sha256 cellar: :any, sonoma:        "2d481ddbd7661039225f75f4117f424e49583f133c6d4c714bfae6700bff0c2a"
    sha256 cellar: :any, arm64_linux:   "fa839529162f81ad41d00229044322bf18c3e2cfbdc8774fdae1f63621a94f6c"
    sha256 cellar: :any, x86_64_linux:  "87a9ccbc1ae6e52ee1cc58a9b1f85c4c3f547247fb796563973b4473c8b08c5e"
  end

  depends_on "cmake" => :build

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.cpp").write <<~CPP
      #include <iostream>
      #include <liborigin/OriginFile.h>

      int main() {
          std::cout << "liborigin version: " << liboriginVersionString() << std::endl;
          return 0;
      }
    CPP

    system ENV.cxx, "-std=c++11", "test.cpp", "-L#{lib}", "-lorigin", "-o", "test"
    assert_match version.to_s, shell_output("./test")
  end
end
