class Davix < Formula
  desc "Library and tools for advanced file I/O with HTTP-based protocols"
  homepage "https://github.com/cern-fts/davix"
  url "https://github.com/cern-fts/davix/releases/download/R_0_8_4/davix-0.8.4.tar.gz"
  sha256 "519d56f746e86ea3fd615bc49e559b520df07e051e1ca3d8c092067958f3b2b7"
  license "LGPL-2.1-or-later"
  revision 1
  head "https://github.com/cern-fts/davix.git", branch: "devel"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "d6c39dcc41daaa79286a5f843a96438016dd3dc12e6b90496fa0c0a8c98879de"
    sha256 cellar: :any,                 arm64_monterey: "63ddded6d7553a2b25b7577a90b6f0b26d71a9b0491aeb0538e6e8d96a453dc2"
    sha256 cellar: :any,                 arm64_big_sur:  "8077eff019705fe76a8bbc059e12a3925cd5e3619a1f5b1709a0efe9d7117dfb"
    sha256 cellar: :any,                 ventura:        "6afd4fc8493c01b9d575ed87d170a8ca3b06b88c6fa7603b43dc8fa124488194"
    sha256 cellar: :any,                 monterey:       "d5d56f9c9fe987cb03a000f86a0b0a7af42a801765ea7ec4c27264e41834f49d"
    sha256 cellar: :any,                 big_sur:        "dfa3470f6a0e655a4c07d5cdf4821e5ed115c1cce287208fe1feec7f7dcd79b0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b41952cfa51be57c74dd2998a8c8d33234082d9b2ea9725d1b8b727bf1996235"
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
    ]

    system "cmake", "-S", ".", "-B", "build", *args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    system "#{bin}/davix-get", "https://brew.sh"
  end
end
