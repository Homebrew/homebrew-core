class Iccdev < Formula
  desc "Developer tools for interacting with and manipulating ICC profiles"
  homepage "https://github.com/InternationalColorConsortium/iccDEV"
  url "https://github.com/InternationalColorConsortium/iccDEV/archive/refs/tags/v2.4.2.6.tar.gz"
  sha256 "78b05fe86a3bdf2dbacf9453a20f81e9ccac8f278d767a6e3e38efbbe8a4bb1e"
  license "BSD-3-Clause"

  # Skip `wasm-` tags
  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    manifest_sha256 "92133424cb84522ea32c708637ef7a9fee52d26d1741473cfcd6a6ea75f3c8d5"
    sha256 cellar: :any, arm64_golden_gate: "896f7bb0936bd8bca5698a2ff348e042b55e98b64f98fda29a51be77f8f7fd24"
    sha256 cellar: :any, arm64_tahoe:       "dc066f3caf74c0a80bca4173af88f163e0256bac7512403a41bfbfc906639a72"
    sha256 cellar: :any, arm64_sequoia:     "e459f822eead20a77b2896e23fd5e01582a58f5c706b7ae728ec9e88ce2aef8f"
    sha256 cellar: :any, arm64_linux:       "b4bc865d94cffcf69a14ddc82f11bcd143d7cd43592a154e1456d6b688049e0f"
    sha256 cellar: :any, x86_64_linux:      "ca71f9635399e947ed1642490de7ea4f51736309b433c1d17bd71262ee2438af"
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
