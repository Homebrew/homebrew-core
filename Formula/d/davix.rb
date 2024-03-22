class Davix < Formula
  desc "Library and tools for advanced file I/O with HTTP-based protocols"
  homepage "https://github.com/cern-fts/davix"
  url "https://github.com/cern-fts/davix/releases/download/R_0_8_5/davix-0.8.5.tar.gz"
  sha256 "f9ce21bcc2ed248f7825059d17577876616258c35177d74fad8f854a818a87f9"
  license "LGPL-2.1-or-later"
  head "https://github.com/cern-fts/davix.git", branch: "devel"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "4cf4dca18507005e724230890fa5a70dde080f27f39b47915bc484f07d34949c"
    sha256 cellar: :any,                 arm64_ventura:  "21689783bbfb19dbd1412a1cac201a95c814bb98361855761affaed90f34057c"
    sha256 cellar: :any,                 arm64_monterey: "92423b49102bce10e2accd1693912dbffe174b0b0cfe85d57e00c08a69cb7ddb"
    sha256 cellar: :any,                 sonoma:         "7005c023ba24c247e12d6de562b0bbc46ecc46fd2f826690d656390d54dcd28d"
    sha256 cellar: :any,                 ventura:        "5e722d24dbd14d51d6b8a3be44c0d904d4bdcbcfe4efcf5a9e5f6ba18718feea"
    sha256 cellar: :any,                 monterey:       "7fabe42ccc68cd7f9db8fbd5f8df869486846cce32ed7e2851a9cc8c390717de"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9c481ce720f59fd0c4da185aa28e01226056a2b029c74506414eeebaf045f598"
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
