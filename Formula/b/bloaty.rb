class Bloaty < Formula
  desc "Size profiler for binaries"
  homepage "https://github.com/google/bloaty"
  url "https://github.com/google/bloaty/releases/download/v1.1/bloaty-1.1.tar.bz2"
  sha256 "a308d8369d5812aba45982e55e7c3db2ea4780b7496a5455792fb3dcba9abd6f"
  license "Apache-2.0"
  revision 25

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_sonoma:   "b1afb7eaa6b88ef167a93060d78b3c5502cd676bde5dea3409ec626eb9e2ed31"
    sha256 cellar: :any,                 arm64_ventura:  "4c9a855ce38c2d0425d32f5d5ac9ba4a913410fb53f1be131185d1694f9395bd"
    sha256 cellar: :any,                 arm64_monterey: "560d56fea8f6c7798c135109f3bb4461861d8e8c29a746449a1a236aab4e47b9"
    sha256 cellar: :any,                 sonoma:         "8961375f5bcf1a7ebe157135c8e1a52075e71fcda83d4fa178e60ec9a0760f62"
    sha256 cellar: :any,                 ventura:        "6ccfc4d232a43eebe0225ac5b7fe7d24806660ec8989e13ca761ed55331475d0"
    sha256 cellar: :any,                 monterey:       "b16b1c1a66b074e592fb508e7d9584fefe5f3926cf40d2b711a755f98b901730"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "52917909740da8dadd44d2b9826b9560ab98a0abb04353df7116b695d49826c2"
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
    abseil_cxx_standard = 17 # Keep in sync with C++ standard in abseil.rb
    inreplace "CMakeLists.txt", "CMAKE_CXX_STANDARD 11", "CMAKE_CXX_STANDARD #{abseil_cxx_standard}"
    inreplace "CMakeLists.txt", "-std=c++11", "-std=c++17"
    system "cmake", "-S", ".", "-B", "build", "-DCMAKE_CXX_STANDARD=#{abseil_cxx_standard}", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    assert_match(/100\.0%\s+(\d\.)?\d+(M|K)i\s+100\.0%\s+(\d\.)?\d+(M|K)i\s+TOTAL/,
                 shell_output("#{bin}/bloaty #{bin}/bloaty").lines.last)
  end
end
