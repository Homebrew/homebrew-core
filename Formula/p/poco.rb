class Poco < Formula
  desc "C++ class libraries for building network and internet-based applications"
  homepage "https://pocoproject.org/"
  url "https://pocoproject.org/releases/poco-1.15.4/poco-1.15.4-all.tar.bz2"
  sha256 "d92e9e6711957a6b4415d4ffe0df5470b229bfa123334865c3b6a065030cd3a8"
  license "BSL-1.0"
  revision 1
  compatibility_version 6
  head "https://github.com/pocoproject/poco.git", branch: "main"

  livecheck do
    url "https://pocoproject.org/releases/"
    regex(%r{href=.*?poco[._-]v?(\d+(?:\.\d+)+\w*)/?["' >]}i)
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "4dcfd8016a852af701b225ec12fe5f09058a35a42894c632f1706629eeb7e98a"
    sha256 cellar: :any, arm64_tahoe:       "44108fc84fd41996338bb43baa0e9a43cc7b6ec37d17fbffcd74bffd45889019"
    sha256 cellar: :any, arm64_sequoia:     "f2291b64afb1a2552622b7ce340588b71e9d90994c38a8e091f78f0dc0848e91"
    sha256 cellar: :any, arm64_linux:       "840a622f6fe19e963dd2a670833e70af7ea7ffa6e0f7db2edc48d4c685ab4528"
    sha256 cellar: :any, x86_64_linux:      "56a0a56930acc6efe217ce37584bde71979c29c240d10ae263cd96ba4c6f28a7"
  end

  depends_on "cmake" => :build
  depends_on "openssl@4"
  depends_on "pcre2"
  depends_on "utf8proc"

  uses_from_macos "expat"
  uses_from_macos "sqlite"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  deny_network_access!

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
