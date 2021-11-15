class Davix < Formula
  desc "Library and tools for advanced file I/O with HTTP-based protocols"
  homepage "https://github.com/cern-fts/davix"
  url "https://github.com/cern-fts/davix/releases/download/R_0_8_0/davix-0.8.0.tar.gz"
  sha256 "2f108da0408a83fb5b9f0c68150d360ba733e4b3a0fe298d45b0d32d28ab7124"
  license "LGPL-2.1-or-later"
  head "https://github.com/cern-fts/davix.git"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "be805f236e6bda40acfbccc744bf856ffdb10bdcf51dc77c4113dc02e8d58de9"
    sha256 cellar: :any,                 arm64_big_sur:  "c48fc0895374ecf6c509f59fe07306b717fc34b2e5c4ce0773740ce7a5bf392f"
    sha256 cellar: :any,                 monterey:       "0fe6613982086ecfd30f9d52de7f3262a48ffd57348bd3c7f9d1f9db54ad5e0f"
    sha256 cellar: :any,                 big_sur:        "4181ed1f39699aace812fdff70a09344abc920c6f4aad9fb61bfb97f3fecbd17"
    sha256 cellar: :any,                 catalina:       "f5c6cbfd4ed205e39a5401cc890ac0a5c0768e36e9e7a515519278144b0ec95a"
    sha256 cellar: :any,                 mojave:         "847ba0b1e3227c85215c5eb54a10da5fc9aa231b98059e3e01080f02b5bc9f55"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2e6cb42036948a4128c8b0c6cc04ec459375113ab93b81d20d6708dd8baf6a3b"
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
