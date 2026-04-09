class Poco < Formula
  desc "C++ class libraries for building network and internet-based applications"
  homepage "https://pocoproject.org/"
  url "https://pocoproject.org/releases/poco-1.15.1/poco-1.15.1-all.tar.bz2"
  sha256 "4fac8f0faaff69623b742edfe0bdfba1804ddb42286bcd8f5aa83e89b4eb4b4f"
  license "BSL-1.0"
  compatibility_version 2
  head "https://github.com/pocoproject/poco.git", branch: "main"

  livecheck do
    url "https://pocoproject.org/releases/"
    regex(%r{href=.*?poco[._-]v?(\d+(?:\.\d+)+\w*)/?["' >]}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "73df2a765bf6fdaeba9b4537bd072d5bb58fecb5022f92e3e4bc6c8b9fefb829"
    sha256 cellar: :any,                 arm64_sequoia: "450e22a06a2232b0fb280d975e9432fe1a45f678f5a32f188607ecf28c322fd1"
    sha256 cellar: :any,                 arm64_sonoma:  "f25021d032a7d516562dbc0b2986658b246be9b1e98c8d0d11f0dedbcbd93d9b"
    sha256 cellar: :any,                 sonoma:        "531651bcf4379fdd5b41fa793efb6edb1ea78c72008c3ce0dc91d436b2ce985d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d59ea6fb9f6bd8d6b57d52de086f485cbb2cea71cb29b8f3bfa54a5348675a16"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "94914185a1609bbb7927d4a4cd6f3ed041f62c40d45cf1ec804c5bf5b16f847e"
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
