class Poco < Formula
  desc "C++ class libraries for building network and internet-based applications"
  homepage "https://pocoproject.org/"
  url "https://pocoproject.org/releases/poco-1.14.2/poco-1.14.2-all.tar.bz2"
  sha256 "7738a4c880f08e89318fc53915f86be5a0e70f14eb1e7f0e1767c8781c40d794"
  license "BSL-1.0"
  head "https://github.com/pocoproject/poco.git", branch: "main"

  livecheck do
    url "https://pocoproject.org/releases/"
    regex(%r{href=.*?poco[._-]v?(\d+(?:\.\d+)+\w*)/?["' >]}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "c05b8a79eff57205d43122e44bb9365e882349ff897a85f78b311987eafad8e9"
    sha256 cellar: :any,                 arm64_sequoia: "4621106047688c99a20361317c0ae95e6496c26c49d094dce8f0a5e667183ac9"
    sha256 cellar: :any,                 arm64_sonoma:  "459cd974221e79e4503c91c228045f75e2a650c21aacb6ce8484c2c9bf7a354b"
    sha256 cellar: :any,                 sonoma:        "098e0c7fc859c8da46d57f3b430c4215f1e4b03f61cf12477c40f2156fde4ce1"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9667b258197cc409a7bc4792f68ec3e6f33e33ff1f0e1f746968b3593062bfdc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c3c9c467ed79cd67933268726df3839d4f406fd964c3658faae8926606962694"
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
