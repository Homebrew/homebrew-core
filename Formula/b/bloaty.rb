class Bloaty < Formula
  desc "Size profiler for binaries"
  homepage "https://github.com/google/bloaty"
  url "https://github.com/google/bloaty/releases/download/v1.1/bloaty-1.1.tar.bz2"
  sha256 "a308d8369d5812aba45982e55e7c3db2ea4780b7496a5455792fb3dcba9abd6f"
  license "Apache-2.0"
  revision 13

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "22dd9bcbac601d7ea34f2202a25cfceba2b6edc2a882211bc3a22503c6771241"
    sha256 cellar: :any,                 arm64_monterey: "2a72c055e1c8a7a6c44e34aa4cb7a743463249cfb2896a1c553f6fc2c02b2a01"
    sha256 cellar: :any,                 arm64_big_sur:  "e0235ecb255f379591bc97ebac923b1fad300f73932e3d95e03773c1c8d22037"
    sha256 cellar: :any,                 ventura:        "d844058edbb0e2f03a1b89c0669cd106f21a68a1548be12faabcc73c372b620a"
    sha256 cellar: :any,                 monterey:       "e44c828a055799042a909a63b9e64dd4d6f964dd775be3173d2507acd14da386"
    sha256 cellar: :any,                 big_sur:        "89369d9574bd17d10ff88854b0206ab1c8ef498960a12b85a4114467bf602ea1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1b8dda1d586c658d0289e515ac012a57b039dcbc7450279b395b9bcfc67ca500"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "abseil"
  depends_on "capstone"
  depends_on "protobuf"
  depends_on "re2"

  # Support system Abseil. Needed for Protobuf 22+.
  # Backport of: https://github.com/google/bloaty/pull/347
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/86c6fb2837e5b96e073e1ee5a51172131d2612d9/bloaty/system-abseil.patch"
    sha256 "d200e08c96985539795e13d69673ba48deadfb61a262bdf49a226863c65525a7"
  end

  def install
    # https://github.com/protocolbuffers/protobuf/issues/9947
    ENV.append_to_cflags "-DNDEBUG"
    # Remove vendored dependencies
    %w[abseil-cpp capstone protobuf re2].each { |dir| (buildpath/"third_party"/dir).rmtree }
    system "cmake", "-S", ".", "-B", "build", "-DCMAKE_CXX_STANDARD=17", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    assert_match(/100\.0%\s+(\d\.)?\d+(M|K)i\s+100\.0%\s+(\d\.)?\d+(M|K)i\s+TOTAL/,
                 shell_output("#{bin}/bloaty #{bin}/bloaty").lines.last)
  end
end
