class Primesieve < Formula
  desc "Fast C/C++ prime number generator"
  homepage "https://github.com/kimwalisch/primesieve"
  url "https://github.com/kimwalisch/primesieve/archive/v7.7.tar.gz"
  sha256 "fcb3f25e68081c54e5d560d6d1f6448d384a7051e9c56d56ee0d65d6d7954db1"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "499d740c168da789900c8bb4754dd128fe09fa8bf81f6ff6b505d4e550b26126"
    sha256 cellar: :any,                 arm64_big_sur:  "c0d7c16fd8c44bc2a0646b3835846b00da3287896c8383a18c0bfe474235ba64"
    sha256 cellar: :any,                 monterey:       "5dc3803bee3857e6407cfcdc02f8cda978ee2e8604e8cbc7ddfb77fe6ea86caa"
    sha256 cellar: :any,                 big_sur:        "f486ad3728875dda3a7756fb8626c7fa57eacaaddb4da3e54dc456c85b070754"
    sha256 cellar: :any,                 catalina:       "554ddd1add66f1e453991967102b40911690173a30ef8008e9630505f0743c4d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d632821ac2c37983469292db437baeb06d86307349e9670fe8aac74ab68970df"
  end

  depends_on "cmake" => :build

  def install
    system "cmake", "-S", ".", "-B", "build", "-DCMAKE_INSTALL_RPATH=#{rpath}", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    system "#{bin}/primesieve", "100", "--count", "--print"
  end
end
