class Poco < Formula
  desc "C++ class libraries for building network and internet-based applications"
  homepage "https://pocoproject.org/"
  url "https://pocoproject.org/releases/poco-1.15.2/poco-1.15.2-all.tar.bz2"
  sha256 "ca56eb58f0b8f44940c1901b8cff0fad2ac95e5b646850efbdd3d76ce8013225"
  license "BSL-1.0"
  compatibility_version 3
  head "https://github.com/pocoproject/poco.git", branch: "main"

  livecheck do
    url "https://pocoproject.org/releases/"
    regex(%r{href=.*?poco[._-]v?(\d+(?:\.\d+)+\w*)/?["' >]}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "934905cf3c812f394df5038a09993105c44a8de61b952e354dca63b3c5c946b6"
    sha256 cellar: :any,                 arm64_sequoia: "66e46aed385bda5da3e6e631d18b1313a1d093f6dd91565680d94e3a7510802b"
    sha256 cellar: :any,                 arm64_sonoma:  "6bd05ed664bdde26c508643e2395142790714e94861498f2004e52fe5b92152f"
    sha256 cellar: :any,                 sonoma:        "f1aef25e16e8b458af4cbbe0907f87faa7268ca8288182c68776cd39658787ef"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7575c9ce0d274baf37ace10f78f458c0feda0b2daacfd88d7df8c3780f287da1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "78ecd404cb34c3efb0b8fc268029022551530c093879819f963b88fe9c414e63"
  end

  depends_on "cmake" => :build
  depends_on "libpng"
  depends_on "openssl@3"
  depends_on "pcre2"
  depends_on "utf8proc"

  uses_from_macos "expat"
  uses_from_macos "sqlite"

  on_linux do
    depends_on "zlib-ng-compat"
  end

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
