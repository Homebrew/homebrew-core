class Geographiclib < Formula
  desc "C++ geography library"
  homepage "https://geographiclib.sourceforge.io/"
  url "https://github.com/geographiclib/geographiclib/archive/refs/tags/r2.3.tar.gz"
  sha256 "cb1135f1612da26bae0eea1e65d97272d2c2c1811f611a8202b08f1ec79c7881"
  license "MIT"
  head "https://github.com/geographiclib/geographiclib.git", branch: "main"

  livecheck do
    url :stable
    regex(/^r(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "a8597b73d5b2b54a9549d36f7a11643f9b8870248c3dc8f990f5f2f91d632c11"
    sha256 cellar: :any,                 arm64_ventura:  "71ee652de927a612a63f04a2247294c326dd99467b7c5529a5e8647b67dbbb71"
    sha256 cellar: :any,                 arm64_monterey: "1afc8116561fb3754d7ea042ede6962c9d831f3161dcec5efd0994ebf7a5742e"
    sha256 cellar: :any,                 arm64_big_sur:  "7bf1c02d15c337fb6572de86570d48e0c9d8941b08c428c3a14d4577e7e20b2f"
    sha256 cellar: :any,                 sonoma:         "41889c90af77ec49e3dc7c8fd97052eb004cda9e3d6d5ddfcb0475914e0d036b"
    sha256 cellar: :any,                 ventura:        "d55c9937ebcaee2d330d2c9fdbdb028a3c55ca03a532f9a3f813b9614eb42b49"
    sha256 cellar: :any,                 monterey:       "d5788296926c278d38a62c43c089866b6ef8a4c155675dd4b6fad5e8ca25dae6"
    sha256 cellar: :any,                 big_sur:        "de73e178a1208bb3addeefb67239a40150f516abe2d0f21fb928d5193d6a1123"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "df083296aba0c949501356f3e90dbc4c8eed17b05de0b444fe8a24d135c72574"
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
