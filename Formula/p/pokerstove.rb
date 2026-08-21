class Pokerstove < Formula
  desc "Poker evaluation and enumeration software"
  homepage "https://github.com/andrewprock/pokerstove"
  url "https://github.com/andrewprock/pokerstove/archive/refs/tags/v1.1.tar.gz"
  sha256 "ee263f579846b95df51cf3a4b6beeb2ea5ea0450ce7f1c8d87ed6dd77b377220"
  license "BSD-3-Clause"
  revision 8

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "657cfd5f80138b60153e00a80f29083bfe533354e8bb59d01ea05f05e12e473d"
    sha256 cellar: :any, arm64_sequoia: "f53dc63b9fb78d0ec507f40e790822eb151177bc78363f0ce9edbe09bb784380"
    sha256 cellar: :any, arm64_sonoma:  "0969644a32bc7ab0b013c266915d15799fd61827016099c25582bf89b7a2b6ad"
    sha256 cellar: :any, sonoma:        "1f1a681481f881041d11a65af1053cf9bb92bc9d6631de73be1d5c454bff59d9"
    sha256 cellar: :any, arm64_linux:   "b59ef4fcdad2d4e2e0e8618fcd4bc655dfe5774ab9af18c4a3b79f900d6eb210"
    sha256 cellar: :any, x86_64_linux:  "7583766bf3fb8b7bc9290ae0b66214d79d019a33e07080736e9c655c3d27e22b"
  end

  depends_on "cmake" => :build
  depends_on "googletest" => :build
  depends_on "boost"

  # Backport commit to build with CMake 4
  patch do
    url "https://github.com/andrewprock/pokerstove/commit/8ca71960b3ee68bf7cbc419d5aee2065276054bb.patch?full_index=1"
    sha256 "379461a6e3258ebf9803ff4a52020d027a745e1676d7aee865f5dd035c51c6e9"
    type :backport
  end

  def install
    system "cmake", "-S", ".", "-B", "build", "-DCMAKE_CXX_STANDARD=14", *std_cmake_args
    system "cmake", "--build", "build"
    prefix.install "build/bin"
  end

  test do
    system bin/"peval_tests"
  end
end
