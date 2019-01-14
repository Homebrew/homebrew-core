class Davix < Formula
  desc "Library and tools for advanced file I/O with HTTP-based protocols"
  homepage "https://dmc.web.cern.ch/projects/davix/home"
  url "https://github.com/cern-it-sdc-id/davix.git",
      :tag      => "R_0_7_1",
      :revision => "414d90721a729c6d1bc6866feebddfc4e2fd4caa"
  version "0.7.1"
  head "https://github.com/cern-it-sdc-id/davix.git"

  bottle do
    cellar :any
    sha256 "86fff80d2ff8aae77220e2bc996151a34c0f4abd0f70abe330572564a71e0a39" => :mojave
    sha256 "f8c3f240c37c06dd16ab41b9fd458a2884296981ce898c13a5911ab628f3a41c" => :high_sierra
    sha256 "cf1a6eaba6c3208b20cc44174ddaa716f39cd9fe5394ade09681749c987c6198" => :sierra
  end

  depends_on "cmake" => :build
  depends_on "doxygen" => :build
  depends_on "python@2" => :build
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
