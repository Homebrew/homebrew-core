class Davix < Formula
  desc "Library and tools for advanced file I/O with HTTP-based protocols"
  homepage "https://github.com/cern-fts/davix"
  url "https://github.com/cern-fts/davix/releases/download/R_0_8_9/davix-0.8.9.tar.gz"
  sha256 "0dc7e3702500fc4a88e037ababf096e8c1cad2532c34e08add043d4dc84283f6"
  license "LGPL-2.1-or-later"
  head "https://github.com/cern-fts/davix.git", branch: "devel"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "c0ba48b0fd441dd8050966106b3821ff16c128d098c8ca43f92207e425651591"
    sha256 cellar: :any,                 arm64_sonoma:  "eef8c6e919892b8a1eca1788fc0592eae95bd9fd9b1ae3cd43c18e2c8e3f72ba"
    sha256 cellar: :any,                 arm64_ventura: "183081e7c4523a0fdcc7629995eb9737b293c013408b20d6027955a2e269378d"
    sha256 cellar: :any,                 sonoma:        "ae9739198bd1f116afa3ca24cd0c3fb978aed6d502dab482d916ed654915c0cb"
    sha256 cellar: :any,                 ventura:       "9bcbe09442b08b7ec14a51b367815944bb18d374af67c654235797d3dbd12247"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "993baf734a3fead95a46435f1c83736185964380b668cacebd8248e8a8626a36"
  end

  depends_on "cmake" => :build
  depends_on "doxygen" => :build
  depends_on "openssl@3"

  uses_from_macos "python" => :build
  uses_from_macos "curl", since: :monterey # needs CURLE_AUTH_ERROR, available since curl 7.66.0
  uses_from_macos "libxml2"

  on_linux do
    depends_on "util-linux"
  end

  def install
    args = std_cmake_args + %W[
      -DEMBEDDED_LIBCURL=FALSE
      -DCMAKE_INSTALL_RPATH=#{rpath}
      -DLIB_SUFFIX=
      -DBENCH_TESTS=FALSE
      -DDAVIX_TESTS=FALSE
    ]

    system "cmake", "-S", ".", "-B", "build", *args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    system bin/"davix-get", "https://brew.sh"
  end
end
