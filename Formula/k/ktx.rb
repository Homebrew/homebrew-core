class Ktx < Formula
  desc "Khronos Texture Library and Tools"
  homepage "https://github.com/KhronosGroup/KTX-Software"
  url "https://github.com/KhronosGroup/KTX-Software/archive/refs/tags/v4.3.2.tar.gz"
  sha256 "74a114f465442832152e955a2094274b446c7b2427c77b1964c85c173a52ea1f"
  license :cannot_represent # too complicated to represent in the formula
  # no HEAD URL because it would require git-lfs and Homebrew doesn't support using that

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  depends_on "cmake" => :build
  depends_on "ninja" => :build

  def install
    # fix assorted rpath and version reporting issues
    inreplace "tools/CMakeLists.txt",
              "INSTALL_RPATH \"@executable_path;/usr/local/lib\"",
              "INSTALL_RPATH \"@executable_path;#{lib}\""
    inreplace "mkversion", "DEF_VER=v4.0", "DEF_VER=v#{version}"

    system "cmake", ".", "-G", "Ninja", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    system bin/"ktx", "create", "--format", "R8G8B8_SRGB", test_fixtures("test.png"), testpath/"test.ktx"
  end
end
