class Geographiclib < Formula
  desc "C++ geography library"
  homepage "https://geographiclib.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/geographiclib/distrib-C++/GeographicLib-2.1.2.tar.gz"
  sha256 "b062b472dae3d371b3005f4ea2fc59af687b8ea76eb23df732ec11c500fba959"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "8c13b49ba4fd61359db8469ac1ad2ae64b70f6757cb073cb085071943c497a94"
    sha256 cellar: :any,                 arm64_monterey: "bfe0a6587b1795fb82b5c1b59c9b34462f720450ae32cb5940f6f3d4daf8b1ff"
    sha256 cellar: :any,                 arm64_big_sur:  "a16bfa8a86ba9e3d72cc97ad1f3fdcb18fe60b16d09bfdcda16b19a12d4b38e2"
    sha256 cellar: :any,                 ventura:        "2037fedcfd23bfe80eb5e9be3f366d7873a2f40f9a3c3e8d95380fc53f5013f1"
    sha256 cellar: :any,                 monterey:       "c6f56914e3a91a17d2fdaccfe69b555936229cf85ec8e49cb331145eaf071a02"
    sha256 cellar: :any,                 big_sur:        "ffeeacbc0e4fc7508d59d8c194b4f898545ad783d1e8e8aa56e5654722c96027"
    sha256 cellar: :any,                 catalina:       "c4f069e57eff006d3f062ffe998ca0a8cefc9c42a93ea7969ec0bc187bef6064"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3aa5a4b955500a20587ef6c0b6a7064cac7e62620a69406ba3af1a002646f0bb"
  end

  depends_on "cmake" => :build

  def install
    mkdir "build" do
      args = std_cmake_args
      args << "-DCMAKE_OSX_SYSROOT=#{MacOS.sdk_path}" if OS.mac?
      args << "-DEXAMPLEDIR="
      system "cmake", "..", *args
      system "make", "install"
    end
  end

  test do
    system bin/"GeoConvert", "-p", "-3", "-m", "--input-string", "33.3 44.4"
  end
end
