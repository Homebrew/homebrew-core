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
    sha256 cellar: :any,                 arm64_ventura:  "f79999fcc8f108a897ade6b07ce177017ee822a46850e44b92878ca92372e1e6"
    sha256 cellar: :any,                 arm64_monterey: "b229f6f493f477d4bd31eb778afc505a22d20077fc41c5f028e0faad51c358d7"
    sha256 cellar: :any,                 arm64_big_sur:  "22d3365baa34b566fb507e00f5a8f4d5f643b9bddd678f971c775a257f1a3e44"
    sha256 cellar: :any,                 ventura:        "8fd086eba10db4edcca0feef600a28228000bcb0e5aa2e93ab8436898d52b93b"
    sha256 cellar: :any,                 monterey:       "3c66c77d586e29804f3213491ec7df90b1aa988bf145c2713a65f4b8b7dc766e"
    sha256 cellar: :any,                 big_sur:        "4bf713bc813cc8ca065fa70826fd33f7b4010024f3b0380ab0db0dea0f16994f"
    sha256 cellar: :any,                 catalina:       "1906d8a821b82d70f07632a8c9815cecb42a5dd7e06d295ee9d50e3a96405e3c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d23a4438d2e52f7a112e76c9bf11167ede3a8d93ca8a0ff5830e5dda01a072f5"
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
