class Bloaty < Formula
  desc "Size profiler for binaries"
  homepage "https://github.com/google/bloaty"
  url "https://github.com/google/bloaty/releases/download/v1.1/bloaty-1.1.tar.bz2"
  sha256 "a308d8369d5812aba45982e55e7c3db2ea4780b7496a5455792fb3dcba9abd6f"
  license "Apache-2.0"
  revision 23

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "ef64d32b5f738c3c4256ecf5544d5529792e05726d444e986c3c62c48ce61677"
    sha256 cellar: :any,                 arm64_ventura:  "296fd46d0f5441f158a133eed1662f3f37cab8dd30256354051e154e564b37e7"
    sha256 cellar: :any,                 arm64_monterey: "7ddafaffa21660095b33665891e25289e836795ca435ecc4d80bd39030138d34"
    sha256 cellar: :any,                 sonoma:         "e3475662b8dbab028c50a9e32d5ec542b10be80e4d1f24d7457d068a4886ca73"
    sha256 cellar: :any,                 ventura:        "eecb5d1c3a62ff975fe1b12a256e2517b2150f1d4f5b9824d515152d910aff10"
    sha256 cellar: :any,                 monterey:       "4f4aa9910f3bfec1ef355ef5696d814940a96878c119a043a15ddef0cd9d5a1f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d57de02bbe368669c6cbdaae4cb880c69fc8c2557a581db1e687605ebf320abf"
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
