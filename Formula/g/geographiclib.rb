class Geographiclib < Formula
  desc "C++ geography library"
  homepage "https://geographiclib.sourceforge.io/"
  url "https://github.com/geographiclib/geographiclib/archive/refs/tags/r2.5.2.tar.gz"
  sha256 "e3d0c996c299046f2607205445afca3982557ee03ea586a32179ef4581e6ff8d"
  license "MIT"
  head "https://github.com/geographiclib/geographiclib.git", branch: "main"

  livecheck do
    url :stable
    regex(/^r(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "c902a3c57d14896d9c2187aa39e653bd25971ff1125345652c50801d3bab817f"
    sha256 cellar: :any,                 arm64_sequoia: "39088909eb85c9a2bfd8ec5d8e1bb9508f54d2afca241caf683a1fd1bb31f2f0"
    sha256 cellar: :any,                 arm64_sonoma:  "b35c381557b5d0a342e7b35324a8df9bd36af7ef9252c677a0177ef556b023c0"
    sha256 cellar: :any,                 arm64_ventura: "c81d2a16894ae18639ae89d33b7303fe893816928688444e900a0300e728db57"
    sha256 cellar: :any,                 sonoma:        "000136e622f180771e8e97d144030dfb51f488ac014826e9e0ae358eeec4d509"
    sha256 cellar: :any,                 ventura:       "c7ca19559c590aa40f3b9d41255dfbbb05fc5688e5a18abded5d40bda8f1b4f0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "de842531fdf7fc4461b9d129ef838e15ae8bee46fce1414e73124c14397cb415"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "974b98b6bec6774610527ad87d068fa434c9ff106894376e3a64879bdfad8e4c"
  end

  depends_on "cmake" => :build

  def install
    args = ["-DEXAMPLEDIR="]
    args << "-DCMAKE_OSX_SYSROOT=#{MacOS.sdk_path}" if OS.mac?
    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    system bin/"GeoConvert", "-p", "-3", "-m", "--input-string", "33.3 44.4"
  end
end
