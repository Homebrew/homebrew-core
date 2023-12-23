class Poco < Formula
  desc "C++ class libraries for building network and internet-based applications"
  homepage "https://pocoproject.org/"
  url "https://pocoproject.org/releases/poco-1.13.0/poco-1.13.0-all.tar.gz"
  sha256 "e3bdebe701a6fe0977254a09e5f9f0d1e8d5be5deb93259596e3118e9a8d4704"
  license "BSL-1.0"
  head "https://github.com/pocoproject/poco.git", branch: "master"

  livecheck do
    url "https://pocoproject.org/releases/"
    regex(%r{href=.*?poco[._-]v?(\d+(?:\.\d+)+\w*)/?["' >]}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "acdbdc618f7683fbe420f91683740eae65144bd5c7025830bbab515b160dabfa"
    sha256 cellar: :any,                 arm64_ventura:  "16ff2c7187ed84f93e56b64ed5012a7f82e2f5f7b7f49e2c326786c26d9e0ab6"
    sha256 cellar: :any,                 arm64_monterey: "a7fe6801fed678f9fa6e078c2419f860aa4b7b04a0045e95d40ae1afd4b1e879"
    sha256 cellar: :any,                 sonoma:         "4f8f3983ec9270721994a6568dc52151c09eb78a82947a7102a0eae6ea913896"
    sha256 cellar: :any,                 ventura:        "a8c68d4b0dc951baee71c2709d28fc4b3ca4c0e0dd129ea455d71644d8ffe649"
    sha256 cellar: :any,                 monterey:       "32950674eaa9bedf15de1df6aa7c8da669a2331745716e682bcb9e5faa3c4454"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "79e244f1c75f34a144bb96c5fa50b5388f0a4ae5dc7ba3d4a8422230ea945771"
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
