class Poco < Formula
  desc "C++ class libraries for building network and internet-based applications"
  homepage "https://pocoproject.org/"
  url "https://pocoproject.org/releases/poco-1.11.2/poco-1.11.2-all.tar.gz"
  sha256 "904b538d4096a60e0d5fe67e8812d12c633508a76e1d73fdff1ec300181eaa1d"
  license "BSL-1.0"
  head "https://github.com/pocoproject/poco.git", branch: "master"

  livecheck do
    url "https://pocoproject.org/releases/"
    regex(%r{href=.*?poco[._-]v?(\d+(?:\.\d+)+)/?["' >]}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "c5803cfda14c21ccc0308d63aee47309308fa8b3a4538769536eb7af15212fdb"
    sha256 cellar: :any,                 arm64_big_sur:  "48c3e8a3c7bb4839ba4476294912c4c638f7e158c0d665eea66aa854002045f9"
    sha256 cellar: :any,                 monterey:       "cee35bb37b7d15eff1b7c76c82e423115c53c417528aa54ada947f4de9d05157"
    sha256 cellar: :any,                 big_sur:        "379a4a4055a10827facf52791873c6040dc349836588cfa18a4d14a938b6e5ae"
    sha256 cellar: :any,                 catalina:       "9d6965f8ae6b9249dd2d4d9c14b02f8e684d60dde9b1a5e48080f3f34ae29c21"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "15f5fb5a0c2d491148ab5cb029d987fc555a07b47d9799e6aa62bdf5eb0adf3c"
  end

  depends_on "cmake" => :build
  depends_on "openssl@1.1"
  depends_on "pcre"

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
