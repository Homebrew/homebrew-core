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
    rebuild 1
    sha256 "a9f7096a10ef3e97e7aa35e501234945d3b6a6f18650a9cc5749cc1e7c7ec5cf" => :mojave
    sha256 "9ff00e42da12068f8218c2e640115274fd8af64e731f7a24ab14a7018323e0fe" => :high_sierra
    sha256 "10c32646773a837326bc2a4f8671fee3e5a0ea972dc5d39592286dd829711107" => :sierra
  end

  depends_on "cmake" => :build
  depends_on "doxygen" => :build
  depends_on "openssl@1.1"

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
