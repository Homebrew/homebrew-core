class Poco < Formula
  desc "C++ class libraries for building network and internet-based applications"
  homepage "https://pocoproject.org/"
  url "https://pocoproject.org/releases/poco-1.12.1/poco-1.12.1-all.tar.gz"
  sha256 "1a32814b7ac2d7ea68f8519d3bad173e8be0c8306a755130388dc62d70330844"
  license "BSL-1.0"
  head "https://github.com/pocoproject/poco.git", branch: "master"

  livecheck do
    url "https://pocoproject.org/releases/"
    regex(%r{href=.*?poco[._-]v?(\d+(?:\.\d+)+)/?["' >]}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "889bff27910a608d5f21a0bbdfde088aa87955cb4eb5b344649836c467928ec1"
    sha256 cellar: :any,                 arm64_big_sur:  "647910d99fe98bb415f0afbc641ba31b20bfc816be3af767f8cb03fa8f1dc621"
    sha256 cellar: :any,                 monterey:       "e8266289ae5f1481e58095a6b52b24511b7bfaf99611dda206b3362b02aa8f96"
    sha256 cellar: :any,                 big_sur:        "649aa493269bf604b5315c4bea46b7559d940d770643df52674d9c2d2f2b95fa"
    sha256 cellar: :any,                 catalina:       "bcc96dd2f8e0ce51e871501bf58ef187d338921ba874526d49ecd81b4dd1ef0c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fe1b69b595e9a61068467cf9ea155fc4a015c392f05d5123aee4e8e4fd12dbc1"
  end

  depends_on "cmake" => :build
  depends_on "openssl@1.1"
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
