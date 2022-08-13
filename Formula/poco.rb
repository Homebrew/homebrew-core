class Poco < Formula
  desc "C++ class libraries for building network and internet-based applications"
  homepage "https://pocoproject.org/"
  url "https://pocoproject.org/releases/poco-1.12.2/poco-1.12.2-all.tar.gz"
  sha256 "642faec888acb619954d870f89c12a834052813306ff8d8a071becb1eee708aa"
  license "BSL-1.0"
  head "https://github.com/pocoproject/poco.git", branch: "master"

  livecheck do
    url "https://pocoproject.org/releases/"
    regex(%r{href=.*?poco[._-]v?(\d+(?:\.\d+)+)/?["' >]}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "4e97f98c2fb41f8ce19584e96b4da3d3ebb249a88b822a51e20a969437283adf"
    sha256 cellar: :any,                 arm64_big_sur:  "581acee0c0c7ef9fd67018df4edf413c950118e299aac7192368079430edc51c"
    sha256 cellar: :any,                 monterey:       "796f707d2664dc470386a0551a3180b6abc27b101d2ee8472fa5eef5236305ca"
    sha256 cellar: :any,                 big_sur:        "2d82e850db4860e7e343e6c9a713408b098615603c62c287c5f0ea5780ea2fc7"
    sha256 cellar: :any,                 catalina:       "f9529787d8abb8adfbeffb32cb35bc5f4dc9a527673eb4077ffc051445b75c81"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "251eff8e8d3e07e03821e7426287f24434ac1eb3879c0e54885fb0f14ab92a9d"
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
