class Poco < Formula
  desc "C++ class libraries for building network and internet-based applications"
  homepage "https://pocoproject.org/"
  url "https://pocoproject.org/releases/poco-1.11.0/poco-1.11.0-all.tar.gz"
  sha256 "9a29a86bb9b889fc4cc5fb45f4ab065a48700ad71ff842340e13d32759281db9"
  license "BSL-1.0"
  head "https://github.com/pocoproject/poco.git", branch: "master"

  livecheck do
    url "https://pocoproject.org/releases/"
    regex(%r{href=.*?poco[._-]v?(\d+(?:\.\d+)+)/?["' >]}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_big_sur: "a9b4b2d1c1c24b81acea5947325bffd2af88426291857c3c23592659ce3957ca"
    sha256 cellar: :any,                 big_sur:       "ec8ca74c0085ccb363451475afd0913463730f5129205ff1e76edf43bcafae1d"
    sha256 cellar: :any,                 catalina:      "15372ab13fe7e6269b7038532c0a05675b12f71df5f5a69c4930d57a16a598c1"
    sha256 cellar: :any,                 mojave:        "2bb42c67ece76fde31d9dd8d79fad23fecbf9ae33231f1601a335829b1f6f3c6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "52fd3511305d75b4c25b2a562a6c3f741cce5abe050f3107a8b9fa2310f9c8de"
  end

  depends_on "cmake" => :build
  depends_on "openssl@1.1"

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args,
                            "-DENABLE_DATA_MYSQL=OFF",
                            "-DENABLE_DATA_ODBC=OFF",
                            "-DCMAKE_INSTALL_RPATH=#{rpath}"
      system "make", "install"
    end
  end

  test do
    system bin/"cpspc", "-h"
  end
end
