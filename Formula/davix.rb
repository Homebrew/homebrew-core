class Davix < Formula
  desc "Library and tools for advanced file I/O with HTTP-based protocols"
  homepage "https://dmc.web.cern.ch/projects/davix/home"
  url "https://github.com/cern-it-sdc-id/davix.git",
      :tag => "R_0_6_6",
      :revision => "32c5f3cf934500a570703c8f6bfc06ede10ed4b8"
  version "0.6.6"
  head "https://github.com/cern-it-sdc-id/davix.git"

  bottle do
    cellar :any
    sha256 "58b587ea2528b80f1fd134c54cd200d3cbbbbf5ef433f6430d8f6c74f8af085a" => :sierra
    sha256 "f595758a61ba591a8b746a4f22336f19abecbbe881ad4e0e7cbec458d13184a8" => :el_capitan
    sha256 "6304f894a261384a80a25838e88bea83a63f753b645dc1c4550d78993fc2fee0" => :yosemite
  end

  depends_on "cmake" => :build
  depends_on "doxygen" => :build
  depends_on "openssl"
  depends_on "ossp-uuid"

  def install
    ENV.libcxx

    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end

  test do
    system "#{bin}/davix-get", "https://www.google.com"
  end
end
