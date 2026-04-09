class Drafter < Formula
  desc "Native C/C++ API Blueprint Parser"
  homepage "https://apiblueprint.org/"
  url "https://github.com/apiaryio/drafter/releases/download/v5.1.0/drafter-v5.1.0.tar.gz"
  sha256 "b3f60d9e77ace0d40d32b892b99852d3ed92e2fd358abd7f43d813c8dc473913"
  license "MIT"
  head "https://github.com/apiaryio/drafter.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:    "d3963fe9e44406c53f2e4f7537dc4eabe78787b558fb9082a93caeaabb69a2db"
    sha256 cellar: :any,                 arm64_sequoia:  "ee2d1f0c252123ab1df0568f94c453dba3bb13a461a48ace73c9a2da3231d22e"
    sha256 cellar: :any,                 arm64_sonoma:   "ae6e70fa4ef8bf01705bb0fa8ea0fda39063b718f9b8e6d2bd2ef7923fbe9ab8"
    sha256 cellar: :any,                 arm64_ventura:  "fdc175f7d034e4233ba5450fabc3f0191f1c29ee75a64eca60ff1023f14b5a41"
    sha256 cellar: :any,                 arm64_monterey: "e8f55148101feadb827546a163df01bb99e4752debdf9954e0d5e343027fcd81"
    sha256 cellar: :any,                 arm64_big_sur:  "89c48cd01697b98c8a8ce91dcd1f2d04016adda52e69f6a4785c3353893b767e"
    sha256 cellar: :any,                 sonoma:         "587d9d52be90fd35b25f696553e6d36035253e0c8b17308a573042f5042da372"
    sha256 cellar: :any,                 ventura:        "b3b7bf960af127738f0e212336255a2b94321a90366d9e01447013e9537c9ae7"
    sha256 cellar: :any,                 monterey:       "4c920f38e6a755f97eb063becfa8da9c11e2dd30b2a99019929b2c896af72e5b"
    sha256 cellar: :any,                 big_sur:        "a9a9a413c78370fbc9d3a47e861e4f4166fab68caea29f2a1ae745a6c963162b"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "b8c30af375bc0f9dd48dfb3ecd7029c1b136a158355a235379678363a766edc1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "00241d159577722e4fb7d98b661a2d81c91e6fa3beaca88d010b6eecea4377b0"
  end

  deprecate! date: "2024-12-04", because: :repo_archived
  disable! date: "2025-12-04", because: :repo_archived

  depends_on "cmake" => :build

  # patch release version
  patch do
    url "https://github.com/apiaryio/drafter/commit/481d0ba83370d2cd45aa1979308cac4c2dbd3ab3.patch?full_index=1"
    sha256 "3c3579ab3c0ae71a4449f547b734023b40a872b82ea81a8ccc0961f1d47e9a25"
  end

  def install
    # Fix to error: no member named 'swap' in namespace 'std'
    if OS.mac? && DevelopmentTools.clang_build_version >= 1700
      inreplace "packages/boost/boost/move/adl_move_swap.hpp",
                "#define BOOST_MOVE_ADL_MOVE_SWAP_HPP",
                "#define BOOST_MOVE_ADL_MOVE_SWAP_HPP\n#include <utility>"
    end

    system "cmake", "-S", ".", "-B", "build", "-DCMAKE_POLICY_VERSION_MINIMUM=3.5", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"api.apib").write <<~EOS
      # Homebrew API [/brew]

      ## Retrieve All Formula [GET /Formula]
      + Response 200 (application/json)
        + Attributes (array)
    EOS
    assert_equal "OK.", shell_output("#{bin}/drafter -l api.apib 2>&1").strip

    assert_match version.to_s, shell_output("#{bin}/drafter --version")
  end
end
