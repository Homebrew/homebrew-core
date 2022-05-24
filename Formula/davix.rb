class Davix < Formula
  desc "Library and tools for advanced file I/O with HTTP-based protocols"
  homepage "https://github.com/cern-fts/davix"
  url "https://github.com/cern-fts/davix/releases/download/R_0_8_1/davix-0.8.1.tar.gz"
  sha256 "3f42f4eadaf560ab80984535ffa096d3e88287d631960b2193e84cf29a5fe3a6"
  license "LGPL-2.1-or-later"
  head "https://github.com/cern-fts/davix.git", branch: "devel"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "94b126cc7cd16f3e057e3e53cae4f29ac0c67b33493e7e233088cbf3a031eb08"
    sha256 cellar: :any,                 arm64_big_sur:  "1352499f99f63e3db5b8bee1c5c33a3c91f01fe0469aba37e730cf345630b8ea"
    sha256 cellar: :any,                 monterey:       "078b736ba2804b062d528d51c1573ce63650efc171fff6be48bda1930a26880a"
    sha256 cellar: :any,                 big_sur:        "d7a35a8730e5b829bb96af49ada8ce8e506306d1bc339811054ac16fb6f25faa"
    sha256 cellar: :any,                 catalina:       "e5e1f1c20c98c6ec7938021b254262689b9a7ede8f948cd9278123b1d8825831"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "55792b06f189367e5f8e0c0820234502d059507794e52ea84992764041704236"
  end

  depends_on "cmake" => :build
  depends_on "doxygen" => :build
  depends_on "openssl@1.1"

  uses_from_macos "libxml2"

  on_linux do
    depends_on "util-linux"
  end

  def install
    system "cmake", ".", *std_cmake_args, "-DCMAKE_INSTALL_RPATH=#{rpath}"
    system "make", "install"
  end

  test do
    system "#{bin}/davix-get", "https://brew.sh"
  end
end
