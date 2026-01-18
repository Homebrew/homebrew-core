class Pokerstove < Formula
  desc "Poker evaluation and enumeration software"
  homepage "https://github.com/andrewprock/pokerstove"
  url "https://github.com/andrewprock/pokerstove/archive/refs/tags/v1.1.tar.gz"
  sha256 "ee263f579846b95df51cf3a4b6beeb2ea5ea0450ce7f1c8d87ed6dd77b377220"
  license "BSD-3-Clause"
  revision 7

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "281850608e647a17bb2b36e1ec2bb048a939687cf6fead379293d7ae54f9d602"
    sha256 cellar: :any,                 arm64_sequoia: "1c122bdfdbbebabf98e2a3f9550239c0813deabb18443a365906c95821659759"
    sha256 cellar: :any,                 arm64_sonoma:  "acd2db1e2142cde60afd927f6dfa11df1e9d9876e8a771ebd3626c0847f822f8"
    sha256 cellar: :any,                 sonoma:        "ac9b605f3ae5dcd1fa51f1654ee40f884a19bf0158269513962c64c5ea912ee0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ce7fe6adf71766c05a0cad8c86b3ded6903b8f5733387840dc0e6f37f905f350"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c5ff08553bb991b7c07f03059117deca775f910cf782c6cbc28642ff9d7cd1f5"
  end

  depends_on "cmake" => :build
  depends_on "googletest" => :build
  depends_on "boost"

  # Backport commit to build with CMake 4
  patch do
    url "https://github.com/andrewprock/pokerstove/commit/8ca71960b3ee68bf7cbc419d5aee2065276054bb.patch?full_index=1"
    sha256 "379461a6e3258ebf9803ff4a52020d027a745e1676d7aee865f5dd035c51c6e9"
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
