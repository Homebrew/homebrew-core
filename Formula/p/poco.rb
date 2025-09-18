class Poco < Formula
  desc "C++ class libraries for building network and internet-based applications"
  homepage "https://pocoproject.org/"
  url "https://pocoproject.org/releases/poco-1.14.1/poco-1.14.1-all.tar.gz"
  sha256 "c4b547070eec8330302ffbfee1d6ba02da2e0e120626f6c5dd52192e5b641f34"
  license "BSL-1.0"
  head "https://github.com/pocoproject/poco.git", branch: "master"

  livecheck do
    url "https://pocoproject.org/releases/"
    regex(%r{href=.*?poco[._-]v?(\d+(?:\.\d+)+\w*)/?["' >]}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "b77df128ce99c553bf3312fb351cc44e06df60133f684dd445913b7faf3e4741"
    sha256 cellar: :any,                 arm64_sequoia: "efd50007f2f6f18fc7d94f03e20796008daefe8a062ebac08bc3731de6a170a7"
    sha256 cellar: :any,                 arm64_sonoma:  "f16b1697467095c8f3e11397022619892223504aeae27d7d33a9c11d655080ee"
    sha256 cellar: :any,                 arm64_ventura: "72df7a28c1e8bb067246452e788a8f1e05de8e748956591b91914227d0217fdb"
    sha256 cellar: :any,                 sonoma:        "814fd9e9e80d345389f66784f78537fce57f887b8710c88320ab70ec9b36e7ce"
    sha256 cellar: :any,                 ventura:       "1e6d1e5b6b0f37747880611b53bfee90133dd8efb6830ac894c141c34dd9c330"
    sha256                               arm64_linux:   "95eb6763038beb833471ceb4c86ac9259d509b78d164ea16704c7009d17a3f72"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b9d80b80347cabba99b05c81ea5cb87c2ade6e93bb6dc445bab172cd48cfc29d"
  end

  depends_on "cmake" => :build
  depends_on "openssl@3"
  depends_on "pcre2"
  depends_on "utf8proc"

  uses_from_macos "expat"
  uses_from_macos "sqlite"
  uses_from_macos "zlib"

  def install
    args = %W[
      -DENABLE_DATA_MYSQL=OFF
      -DENABLE_DATA_ODBC=OFF
      -DCMAKE_INSTALL_RPATH=#{rpath}
      -DPOCO_UNBUNDLED=ON
    ]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    system bin/"cpspc", "-h"
  end
end
