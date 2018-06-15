class Davix < Formula
  desc "Library and tools for advanced file I/O with HTTP-based protocols"
  homepage "https://dmc.web.cern.ch/projects/davix/home"
  url "https://github.com/cern-it-sdc-id/davix.git",
      :tag => "R_0_6_8",
      :revision => "7d9ae02fd29256399e72a400fc0a1f9af7c233d9"
  version "0.6.8"
  head "https://github.com/cern-it-sdc-id/davix.git"

  bottle do
    cellar :any
    sha256 "3fa224f7f2099030860ea04b5a06ef0cab8eb1e1e3ad53f765274c31eec8626c" => :high_sierra
    sha256 "8ed83d7e8367d1156fff19940f2ce360b9d069cf99f4b367f979b5f756d60963" => :sierra
    sha256 "66bbeb6fa8cd77823581a15337da9e9446d5cd1126e8d6986d77735c112f1185" => :el_capitan
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
