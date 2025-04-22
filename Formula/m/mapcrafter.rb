class Mapcrafter < Formula
  desc "Minecraft map renderer"
  homepage "https://github.com/mapcrafter/mapcrafter"
  url "https://github.com/mapcrafter/mapcrafter/archive/refs/tags/v.2.4.tar.gz"
  sha256 "f3b698d34c02c2da0c4d2b7f4e251bcba058d0d1e4479c0418eeba264d1c8dae"
  license "GPL-3.0-or-later"
  revision 14

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "cf44a24edf03e087564b71015e5d4850e1a381e5577d0b0f328b91deb42991f9"
    sha256 cellar: :any,                 arm64_sonoma:  "33a53c814d6290f940b3381f19fcbf150e1073e53492b1d359a7810fb7494340"
    sha256 cellar: :any,                 arm64_ventura: "90e69caaa3caa385e93e053b2933b4d8d56ef5220cfe3b662ff18ef66b663e22"
    sha256 cellar: :any,                 sonoma:        "b0345c0382d6dbad06e25f58f52e3d25835cf236d0d460b06faeac65dcff96f9"
    sha256 cellar: :any,                 ventura:       "5d758ab032c8da63851103cc4f8e1024f48ef58abeddf75e6a8918d8f3b86ca7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "24a6e30afa385527820775880d487d2752eb59bd779e5be0d7d7651368b8b240"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ecb89abeca0415b5cba90d2251d01ea2d66a29611880b951341d6bb5345d7a60"
  end

  depends_on "cmake" => :build
  depends_on "boost"
  depends_on "jpeg-turbo"
  depends_on "libpng"

  # Fix build with `boost` 1.85.0 using open PR.
  # PR ref: https://github.com/mapcrafter/mapcrafter/pull/394
  patch do
    url "https://github.com/mapcrafter/mapcrafter/commit/28dbc86803650eb487782e937cbb4513dbd0a650.patch?full_index=1"
    sha256 "55edc91aee2fbe0727282d8b3e967ac654455e7fb4ca424c490caf7556eca179"
  end

  def install
    system "cmake", "-S", ".", "-B", "build",
                    "-DCMAKE_INSTALL_RPATH=#{rpath}",
                    "-DCMAKE_POLICY_VERSION_MINIMUM=3.5",
                    "-DOPT_SKIP_TESTS=ON",
                    "-DJPEG_INCLUDE_DIR=#{Formula["jpeg-turbo"].opt_include}",
                    "-DJPEG_LIBRARY=#{Formula["jpeg-turbo"].opt_lib/shared_library("libjpeg")}",
                    *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    assert_match(/Mapcrafter/, shell_output("#{bin}/mapcrafter --version"))
  end
end
