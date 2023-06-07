class Davix < Formula
  desc "Library and tools for advanced file I/O with HTTP-based protocols"
  homepage "https://github.com/cern-fts/davix"
  url "https://github.com/cern-fts/davix/releases/download/R_0_8_4/davix-0.8.4.tar.gz"
  sha256 "519d56f746e86ea3fd615bc49e559b520df07e051e1ca3d8c092067958f3b2b7"
  license "LGPL-2.1-or-later"
  head "https://github.com/cern-fts/davix.git", branch: "devel"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "d097fd880d61f49fb8cbdca947203603450a5fdec7c3ee58c3b72a64ce29a241"
    sha256 cellar: :any,                 arm64_monterey: "f9bd73e666a7f78a1e2d96d60b003a4235771b72e18c4f207a54d5c474af6c36"
    sha256 cellar: :any,                 arm64_big_sur:  "4c0356cc3cdba514da6433d3804f9aa790eed4306de31e365ac0b8428a66c922"
    sha256 cellar: :any,                 ventura:        "cbc28b6940e57b9ce058493420bd4d3595dfd92464ef378ac0fe7e62e1b5371f"
    sha256 cellar: :any,                 monterey:       "af63e284ce3eb0563d8f6b1afa7b2940c068176c7f33197e3e882978ecd9806b"
    sha256 cellar: :any,                 big_sur:        "98165dc61aa147d9c3e11241397e52eba6381ab1953f15adafd986895e021503"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fc5b4780fbdc1300e7a0c70b23dfd7d8b53f4718ef90e2f6ff083d13f6acba3d"
  end

  depends_on "cmake" => :build
  depends_on "doxygen" => :build
  depends_on "openssl@1.1"

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
    ]

    system "cmake", "-S", ".", "-B", "build", *args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    system "#{bin}/davix-get", "https://brew.sh"
  end
end
