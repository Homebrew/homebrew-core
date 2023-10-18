class Cmark < Formula
  desc "Strongly specified, highly compatible implementation of Markdown"
  homepage "https://commonmark.org/"
  url "https://github.com/commonmark/cmark/archive/0.30.3.tar.gz"
  sha256 "85e9fb515531cc2c9ae176d693f9871774830cf1f323a6758fb187a5148d7b16"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "7dcb443171d173b527a6ca2de5c12df5121fc76902d51df4073e3a5413c4d42d"
    sha256 cellar: :any,                 arm64_ventura:  "0b22613ee9aa75990bdb4bbbfc6166ef8d176b17c8caf7bbad25ed0738841a7b"
    sha256 cellar: :any,                 arm64_monterey: "739ea11aa0a356b621c49661721ceb371e3c5ea56c244328bd10aae74a0f95a4"
    sha256 cellar: :any,                 arm64_big_sur:  "162ade26201f90662fc6305a83c72ae2a550ddc4326ccf453d5ab1fd85879c25"
    sha256 cellar: :any,                 sonoma:         "3cf663a9d6067969d66712400e20a9def27b24bfcfd7e6c73b7c529807e8a74f"
    sha256 cellar: :any,                 ventura:        "ea945f37fb8de82dffc9ba85f6592b564036228e7ee2ba49951bc639b51266c6"
    sha256 cellar: :any,                 monterey:       "43e230aa0745cc9362d1f2f7c1d85424005690242c725117d3a88be8b88d31c2"
    sha256 cellar: :any,                 big_sur:        "cef92df088c591e3b123ad841a0773fd75c4961d59f701b5e6d27902ecde14af"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f35b1d16c83135d09f2f022a0e4f5a25479feea6411c5115bd8dddfc866f4d1a"
  end

  depends_on "cmake" => :build
  uses_from_macos "python" => :build

  conflicts_with "cmark-gfm", because: "both install a `cmark.h` header"

  def install
    system "cmake", "-S", ".", "-B", "build",
                        "-DCMAKE_INSTALL_LIBDIR=lib",
                        *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    output = pipe_output("#{bin}/cmark", "*hello, world*")
    assert_equal "<p><em>hello, world</em></p>", output.chomp
  end
end
