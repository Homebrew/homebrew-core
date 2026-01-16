class Mapcrafter < Formula
  desc "Minecraft map renderer"
  homepage "https://github.com/mapcrafter/mapcrafter"
  url "https://github.com/mapcrafter/mapcrafter/archive/refs/tags/v.2.4.tar.gz"
  sha256 "f3b698d34c02c2da0c4d2b7f4e251bcba058d0d1e4479c0418eeba264d1c8dae"
  license "GPL-3.0-or-later"
  revision 16

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "44a442066454eea4959b0e1f8f25e2c1623760b204daa6a7a8e544a371012148"
    sha256 cellar: :any,                 arm64_sequoia: "f4e6c89d02bfc0ec7aae345aab5c4810228c7a1b133ac954ba453bf539dd34c0"
    sha256 cellar: :any,                 arm64_sonoma:  "3f78e525d85fab8817bc08c020b352476448db63e3394c2c1dc12e5326ecc1cf"
    sha256 cellar: :any,                 sonoma:        "90993b42b43e2ae3468bf0f7958cce1eb30f6fc6af25c7703f2a2b1d8736aeb8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3e1ce922fd20957bb2b790df53252375b32746b79f92eae4fb173500e3bd144b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7e038bf639acca928a12529990bbe8f6fe8eca1b96f98cea7728645f1ae7c222"
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
