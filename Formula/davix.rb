class Davix < Formula
  desc "Library and tools for advanced file I/O with HTTP-based protocols"
  homepage "https://dmc.web.cern.ch/projects/davix/home"
  url "https://github.com/cern-fts/davix/releases/download/R_0_7_6/davix-0.7.6.tar.gz"
  sha256 "a2e7fdff29f7ba247a3bcdb08ab1db6d6ed745de2d3971b46526986caf360673"
  license "LGPL-2.1"
  head "https://github.com/cern-fts/davix.git"

  bottle do
    cellar :any
    sha256 "31228a01aae02ff881132588f85e59c563d3bcaf206f7600afb16eed76f478c8" => :catalina
    sha256 "d7af8ace083026f5fbbebc6e986162b16f651df17bd64a5303f6f4af6a110a9c" => :mojave
    sha256 "562abf97a898044427a6f968145208d27ada1bf7b6e793fb64eb6fef5864731a" => :high_sierra
  end

  depends_on "cmake" => :build
  depends_on "doxygen" => :build
  depends_on "openssl@1.1"

  uses_from_macos "libxml2"

  on_linux do
    depends_on "util-linux"
  end

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end

  test do
    system "#{bin}/davix-get", "https://brew.sh"
  end
end
