class Lutok < Formula
  desc "Lightweight C++ API for Lua"
  homepage "https://github.com/jmmv/lutok"
  url "https://github.com/jmmv/lutok/releases/download/lutok-0.4/lutok-0.4.tar.gz"
  sha256 "2cec51efa0c8d65ace8b21eaa08384b77abc5087b46e785f78de1c21fb754cd5"
  license "BSD-3-Clause"
  revision 2

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "3303d39bfed8576c90cdc019ab9b6984f90e57b5e5a7facc955dc06fc0664d02"
    sha256 cellar: :any,                 arm64_monterey: "22ff0adc8a95ee3329f51de5b49dfa78ea41651b449877317b1ad631f6c1a210"
    sha256 cellar: :any,                 arm64_big_sur:  "97cc58e57eb823ca7be58be09b8f36e5bd431150391ccb50e1d0647205089430"
    sha256 cellar: :any,                 ventura:        "926ae8331c4eda228aa5c90c7684999b5bfb0d0da256c3a5981c6d64ad3fa0e2"
    sha256 cellar: :any,                 monterey:       "06a97c8c728734827f019dac9cf01f0e7ec06652bd436f531332c93e0682f77d"
    sha256 cellar: :any,                 big_sur:        "5d0c028406ba39fe3f26f3994d3454935e5f38f07018b03a953f9aff81999b6a"
    sha256 cellar: :any,                 catalina:       "83f0706e4b12f54145a8fded793efcbde5cf16ca8c53122987f4c22bc5f87fd5"
    sha256 cellar: :any,                 mojave:         "cfaf7b932bb1eba280ae9353377e7069b8e73585bced5aff0fb4cc9e501f7055"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8d8ce236e89a71233f9ff42e9d6ad46c4ac504f3c6684e1af98d6659f07c59f8"
  end

  depends_on "pkg-config" => :build
  depends_on "lua"

  # Fix -flat_namespace being used on Big Sur and later.
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/03cf8088210822aa2c1ab544ed58ea04c897d9c4/libtool/configure-pre-0.4.2.418-big_sur.diff"
    sha256 "83af02f2aa2b746bb7225872cab29a253264be49db0ecebb12f841562d9a2923"
  end

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make"
    ENV.deparallelize
    system "make", "check"
    system "make", "install"
    system "make", "installcheck"
  end
end
