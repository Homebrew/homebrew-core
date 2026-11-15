class Iccdev < Formula
  desc "Developer tools for interacting with and manipulating ICC profiles"
  homepage "https://github.com/InternationalColorConsortium/iccDEV"
  url "https://github.com/InternationalColorConsortium/iccDEV/archive/refs/tags/v2.4.2.5.tar.gz"
  sha256 "aecf543f58b61bf3dd86c87674960d99ec0a7949b81d247106831945eb78ed34"
  license "BSD-3-Clause"

  # Skip `wasm-` tags
  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "f13b5d063d893ce4a42ba11ac1f063283e752b500447053a9e8bd7fe7a401fee"
    sha256 cellar: :any, arm64_tahoe:       "fe765fbb0d7f40bfe0f5b94ba5fd34a978a3fe320996829a29bc0cecadb199db"
    sha256 cellar: :any, arm64_sequoia:     "2791bfada55a547bae60795bc49fe1bded9c8f2f90346d79a489ccb642943218"
    sha256 cellar: :any, arm64_linux:       "a40711fd28be03613603b27295d2f8a81a13f5d957f53818253d2f884acb48b8"
    sha256 cellar: :any, x86_64_linux:      "c67ce19f97a51de32ddad40ede38cacfec20026d6493ebf75a15955dc0fe1af8"
  end

  depends_on "cmake" => :build
  depends_on "nlohmann-json" => :build
  depends_on "jpeg-turbo"
  depends_on "libpng"
  depends_on "libtiff"
  depends_on "wxwidgets"

  uses_from_macos "libxml2"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  deny_network_access!

  def install
    args = %W[
      -DCMAKE_INSTALL_RPATH=#{rpath}
    ]

    system "cmake", "-S", "Build/Cmake", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    pkgshare.install "Testing/Calc/CameraModel.xml"
  end

  test do
    system bin/"iccFromXml", pkgshare/"CameraModel.xml", "output.icc"
    assert_path_exists testpath/"output.icc"

    system bin/"iccToXml", "output.icc", "output.xml"
    assert_path_exists testpath/"output.xml"
  end
end
