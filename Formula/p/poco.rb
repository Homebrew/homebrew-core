class Poco < Formula
  desc "C++ class libraries for building network and internet-based applications"
  homepage "https://pocoproject.org/"
  url "https://pocoproject.org/releases/poco-1.14.0/poco-1.14.0-all.tar.gz"
  sha256 "983bfd9c15ec78b9c79ef7b387766d5e7bdd0cee1e41114ceebce93bca724561"
  license "BSL-1.0"
  head "https://github.com/pocoproject/poco.git", branch: "master"

  livecheck do
    url "https://pocoproject.org/releases/"
    regex(%r{href=.*?poco[._-]v?(\d+(?:\.\d+)+\w*)/?["' >]}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "40f89c5a6e7d1b26a510ee3982a98b3ff7781d593143ca50a4cb136d64c470b7"
    sha256 cellar: :any,                 arm64_sonoma:  "f5f20a9692b64ee0630cbced01a5d7a2023f0c58a229e42f425d99f6b66404fa"
    sha256 cellar: :any,                 arm64_ventura: "7e0fc08d6222043ee3c2949c925af5af810620e893224751e88ee8f54e652e56"
    sha256 cellar: :any,                 sonoma:        "943d5c02969b69b54afb915f60d5d9fd4ec742bb5827a24f9cbe8a3417be7dbb"
    sha256 cellar: :any,                 ventura:       "aac84ef5b05774d3b71ada6546b60f3b0692818af0022719fba29429f4326dbb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "701f8400dbf9be3f38daaf064c0fd7c4350ca7829acba75974b1c58c60a6aef8"
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
