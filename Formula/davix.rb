class Davix < Formula
  desc "Library and tools for advanced file I/O with HTTP-based protocols"
  homepage "https://dmc.web.cern.ch/projects/davix/home"
  url "https://github.com/cern-it-sdc-id/davix.git",
    :revision => "3489ad37c09d002283ccb42d55dc9beca4a1fe1a",
    :tag => "R_0_6_5"
  version "0.6.5"

  head "https://github.com/cern-it-sdc-id/davix.git"

  bottle do
    cellar :any
    sha256 "a29932da10389d7ca84aae0b027ce6569e15079c91d390efc2b2205fdf83db2f" => :sierra
    sha256 "dfe15dab9d440ceecf2ab2aa21fc905d16521de72c59c581748bddf706152afe" => :el_capitan
    sha256 "df5889e6dcee1cd77d94857c4bbcfd143add707af36c72e1f16ba9cf806a3f2b" => :yosemite
  end

  depends_on "cmake" => :build
  depends_on "doxygen" => :build
  depends_on "openssl"

  def install
    ENV.libcxx

    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end

  test do
    system "#{bin}/davix-get", "https://www.google.com"
  end
end
