class Davix < Formula
  desc "Library and tools for advanced file I/O with HTTP-based protocols"
  homepage "https://dmc.web.cern.ch/projects/davix/home"
  url "https://github.com/cern-fts/davix.git",
      :tag      => "R_0_7_5",
      :revision => "4b04a98027ff5ce94e18e3b110420f1ff912a32c"
  version "0.7.5"
  head "https://github.com/cern-fts/davix.git"

  bottle do
    cellar :any
    sha256 "ff71336ee9cb90a7de9efe97a1c852198b33c93dd62efe8249a99464cac47fc5" => :mojave
    sha256 "92370c9413f7d3061116f294da3431c0615dce0bfb21c0be5c7bdba5111dcdf4" => :high_sierra
    sha256 "6541ea196d445421246b6c95b6da8fc15f1ed900b5bf4b7604c5bd5d70d7a9ae" => :sierra
  end

  depends_on "cmake" => :build
  depends_on "doxygen" => :build
  depends_on "openssl"

  def install
    ENV.libcxx

    cp "release.cmake", "version.cmake"
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end

  test do
    system "#{bin}/davix-get", "https://www.google.com"
  end
end
