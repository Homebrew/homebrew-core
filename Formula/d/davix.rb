class Davix < Formula
  desc "Library and tools for advanced file I/O with HTTP-based protocols"
  homepage "https://github.com/cern-fts/davix"
  url "https://github.com/cern-fts/davix/releases/download/R_0_8_6/davix-0.8.6.tar.gz"
  sha256 "7383b6f6595c77a9dc8c03c5483c67dc32bd6d23751e956cf9c174768e7eeb5b"
  license "LGPL-2.1-or-later"
  head "https://github.com/cern-fts/davix.git", branch: "devel"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "63f3d6ae3f948f10848bf300834b115e49fe975a13aff0ead97dd1c1a94adfb9"
    sha256 cellar: :any,                 arm64_ventura:  "a9bf80372d40cbcb0bbe1ac9402d28b2904b2160d4199c9fe22337975e02f85c"
    sha256 cellar: :any,                 arm64_monterey: "e0c075112133133bc67aee15ee18f85fabe4544f00835bb48b0606f05ba94d36"
    sha256 cellar: :any,                 sonoma:         "c5e79b54981bd253923a9759e3941f8f5e560b4501d040ab2ebffc15f6bd5dce"
    sha256 cellar: :any,                 ventura:        "b0ace78d968c3ef59d59ded5dec2be674bb428ee5777a3cf89c232d6a0e8dd21"
    sha256 cellar: :any,                 monterey:       "dd8d4f1bdade915a02d53647b8aef5c7d9678e3c82710b79b79e05149a027f3e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "52835912bf20d9bb20c1894ebb71d52c22877f4a00ef8582a94abc9b0e7fbc7c"
  end

  depends_on "cmake" => :build
  depends_on "doxygen" => :build
  depends_on "openssl@3"

  uses_from_macos "python" => :build
  uses_from_macos "curl", since: :monterey # needs CURLE_AUTH_ERROR, available since curl 7.66.0
  uses_from_macos "libxml2"

  on_linux do
    depends_on "util-linux"
  end

  def install
    args = std_cmake_args + %W[
      -DEMBEDDED_LIBCURL=FALSE
      -DCMAKE_INSTALL_RPATH=#{rpath}
      -DLIB_SUFFIX=
    ]

    system "cmake", "-S", ".", "-B", "build", *args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    system "#{bin}/davix-get", "https://brew.sh"
  end
end
