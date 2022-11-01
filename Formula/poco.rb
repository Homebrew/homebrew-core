class Poco < Formula
  desc "C++ class libraries for building network and internet-based applications"
  homepage "https://pocoproject.org/"
  url "https://pocoproject.org/releases/poco-1.12.4/poco-1.12.4-all.tar.gz"
  sha256 "4c3584daa5b0e973f268654dbeb1171ec7621e358b2b64363cd1abd558a68777"
  license "BSL-1.0"
  head "https://github.com/pocoproject/poco.git", branch: "master"

  livecheck do
    url "https://pocoproject.org/releases/"
    regex(%r{href=.*?poco[._-]v?(\d+(?:\.\d+)+)/?["' >]}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "8306d22040d0a242160e4b533ecc5f5c43223d5d4791cca3731cf8497f708bf2"
    sha256 cellar: :any,                 arm64_monterey: "ea8a36ed59aaae302d46e3203af7c1b84e1ed80482cef7ed6b0d1aa7dcd7f6bd"
    sha256 cellar: :any,                 arm64_big_sur:  "79b640a8be70da043f299bc2fd48c58e94464cefeaf265a003f4b9a341cda224"
    sha256 cellar: :any,                 monterey:       "9f574802b97c076ba8d09476e5a543b7a5786e6d955d914c6b0e909e8ae9e2c4"
    sha256 cellar: :any,                 big_sur:        "bb0bd5ffd524f9b4a4f560a3bcca61d2f31cd12e35e936a5c49472e2c1feb7c9"
    sha256 cellar: :any,                 catalina:       "c9426e032dd4ebc18af43704da73664564d27149d6bfacc9ef2a4220afdac842"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e473ccfa05c075f9f06208c61b7a981eb4fff8a4549a2b19b232c2e95fb395dd"
  end

  depends_on "cmake" => :build
  depends_on "openssl@3"
  depends_on "pcre2"

  uses_from_macos "expat"
  uses_from_macos "sqlite"
  uses_from_macos "zlib"

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args,
                    "-DENABLE_DATA_MYSQL=OFF",
                    "-DENABLE_DATA_ODBC=OFF",
                    "-DCMAKE_INSTALL_RPATH=#{rpath}",
                    "-DPOCO_UNBUNDLED=ON"
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    system bin/"cpspc", "-h"
  end
end
