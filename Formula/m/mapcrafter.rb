class Mapcrafter < Formula
  desc "Minecraft map renderer"
  homepage "https://github.com/mapcrafter/mapcrafter"
  url "https://github.com/mapcrafter/mapcrafter/archive/refs/tags/v.2.4.tar.gz"
  sha256 "f3b698d34c02c2da0c4d2b7f4e251bcba058d0d1e4479c0418eeba264d1c8dae"
  license "GPL-3.0-or-later"
  revision 17

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "dd44dccfe0adeed4db160301b2a776afeb3589ad30c39713e3d82c72b5cdeba5"
    sha256 cellar: :any, arm64_sequoia: "ef540323a00f9c74a70826a6935af233177dbdbd3b91fd20553f7c8a4a1acd7f"
    sha256 cellar: :any, arm64_sonoma:  "e5115bd315fd5a1dfd40c99430301b6b3d22df8f97c6e5de1e004a46ff655038"
    sha256 cellar: :any, sonoma:        "92892602ca2e7adee1b1316e2ff91cf72f8ecc09eed5eed29a70c38f0488cc38"
    sha256 cellar: :any, arm64_linux:   "b5d1108aeb9573c164dbf25ae5634d3d923562f80ef9cf5d53faa16e9f95bcbb"
    sha256 cellar: :any, x86_64_linux:  "70f5bad7f52160393cf446487d7afd8046b7d6eaa0854c707c22bb6ce08b1100"
  end

  depends_on "cmake" => :build
  depends_on "boost"
  depends_on "jpeg-turbo"
  depends_on "libpng"

  # Fix build with `boost` 1.85.0 using open PR.
  patch do
    url "https://github.com/mapcrafter/mapcrafter/commit/28dbc86803650eb487782e937cbb4513dbd0a650.patch?full_index=1"
    sha256 "55edc91aee2fbe0727282d8b3e967ac654455e7fb4ca424c490caf7556eca179"
    type :unofficial
    resolves "https://github.com/mapcrafter/mapcrafter/pull/394"
  end

  # Fix build with `boost` 1.89.0 using open PR.
  patch do
    url "https://github.com/mapcrafter/mapcrafter/commit/f804a574cbf5b098439698f6f92e1a39244371f1.patch?full_index=1"
    sha256 "d9e9da9cbdb4bb961edd371265304c3999e5322d110f6d72e8580820b2ac2edc"
    type :unofficial
    resolves "https://github.com/mapcrafter/mapcrafter/pull/395"
  end

  def install
    system "cmake", "-S", ".", "-B", "build",
                    "-DCMAKE_INSTALL_RPATH=#{rpath}",
                    "-DCMAKE_POLICY_VERSION_MINIMUM=3.5",
                    "-DOPT_SKIP_TESTS=ON",
                    "-DJPEG_INCLUDE_DIR=#{formula_opt_include("jpeg-turbo")}",
                    "-DJPEG_LIBRARY=#{formula_opt_lib("jpeg-turbo")/shared_library("libjpeg")}",
                    *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    assert_match(/Mapcrafter/, shell_output("#{bin}/mapcrafter --version"))
  end
end
