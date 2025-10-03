class Mapcrafter < Formula
  desc "Minecraft map renderer"
  homepage "https://github.com/mapcrafter/mapcrafter"
  url "https://github.com/mapcrafter/mapcrafter/archive/refs/tags/v.2.4.tar.gz"
  sha256 "f3b698d34c02c2da0c4d2b7f4e251bcba058d0d1e4479c0418eeba264d1c8dae"
  license "GPL-3.0-or-later"
  revision 15

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "cfc65e2f4b77a2c1d329e8f19a5895c91f0ff876b232c2397a4e736f41423eb1"
    sha256 cellar: :any,                 arm64_sequoia: "1efb0a38f77cdfd4eb0e609e505104b1939b9c5142f4478235c27b656725e02d"
    sha256 cellar: :any,                 arm64_sonoma:  "43f21cc8321851928f1ee79a9f6141adbfb246ef0e6c5e4e752edc56a4aaed08"
    sha256 cellar: :any,                 arm64_ventura: "d4ca79a0c71b13a2390a7c3f550de43406977ca7c4bd58667992d0acb0f412e8"
    sha256 cellar: :any,                 sonoma:        "73a30f66f41866bb65c4db45bbafe3d1707adb93836a3befe086101f7f264272"
    sha256 cellar: :any,                 ventura:       "bc4c01693cc22677a5725dab9cfaefec74e5d8e22a16458df7bc0a5f4c02dbe2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b9c0a7231c00c737cc8a547e202c8d88709f7d93772970be328f14379590afbd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0a57a59be26e5837e11cc30385530b9455c09a682d50754508e79e01fec03105"
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

  # Fix build with `boost` 1.89.0 using open PR.
  # PR ref: https://github.com/mapcrafter/mapcrafter/pull/395
  patch do
    url "https://github.com/mapcrafter/mapcrafter/commit/f804a574cbf5b098439698f6f92e1a39244371f1.patch?full_index=1"
    sha256 "d9e9da9cbdb4bb961edd371265304c3999e5322d110f6d72e8580820b2ac2edc"
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
