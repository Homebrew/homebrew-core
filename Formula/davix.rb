class Davix < Formula
  desc "Library and tools for advanced file I/O with HTTP-based protocols"
  homepage "https://github.com/cern-fts/davix"
  url "https://github.com/cern-fts/davix/releases/download/R_0_8_2/davix-0.8.2.tar.gz"
  sha256 "8817a24c23f1309b9de233b9a882455f457c42edc2a649dc70fe2524cf76d94c"
  license "LGPL-2.1-or-later"
  head "https://github.com/cern-fts/davix.git", branch: "devel"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "b3fd12cecd1b960af4fe7c80b9e0156ed3a4dd5108bac3dcc1ed9dab36ba86b3"
    sha256 cellar: :any,                 arm64_big_sur:  "52c5577ca06e32e59d20bb237fff2e79c908114e7742126ba3f7e471b395c288"
    sha256 cellar: :any,                 monterey:       "1ce55fe29cb8731fb72628d8814f4ddca26020b7e28e97839ff7b9d27a73dd8d"
    sha256 cellar: :any,                 big_sur:        "85241ccaba4ad6a5e118dc385444a93e86b48410f1fe1522003e133d15c01af6"
    sha256 cellar: :any,                 catalina:       "b50ca24dc6bf232d18a0f32463064107005f462bb5242555158ac5c385fa7a24"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "63f6b0cb5a38765039975cc57a1726fa7561cc1c2f937ac58f095de781e08bcb"
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
    ]

    system "cmake", "-S", ".", "-B", "build", *args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    system "#{bin}/davix-get", "https://brew.sh"
  end
end
