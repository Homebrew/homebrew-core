class Bloaty < Formula
  desc "Size profiler for binaries"
  homepage "https://github.com/google/bloaty"
  url "https://github.com/google/bloaty/releases/download/v1.1/bloaty-1.1.tar.bz2"
  sha256 "a308d8369d5812aba45982e55e7c3db2ea4780b7496a5455792fb3dcba9abd6f"
  license "Apache-2.0"
  revision 37

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "dd24996db87e0756384539d8c2598aa55d0349c12b5b6147fd247dee1be37af5"
    sha256 cellar: :any,                 arm64_sonoma:  "d53ee453c66dac7c2224878716db04dd061042d6db76d8677805500adb2ac1a3"
    sha256 cellar: :any,                 arm64_ventura: "a5cafe2334eacd9edbbf40e50b70f7edeaa8d9353f1c265ce191093d2a0436f4"
    sha256 cellar: :any,                 sonoma:        "3e7feff675fb3fb19547ca13cbd574e75858f2beff4cc0dae5cf0c34c9077d22"
    sha256 cellar: :any,                 ventura:       "133138d221950a08502d2fe07503dac2e4e91bfc57ffa189a77caf09e7410a80"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bd894c5366b869c0f04cd0c7b070179cf7ba2df99be977a03f0a740c75b8ee8c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f41cb1f19e27ec162ed15777401528db2e4b3806f4d941ef099506b5066407df"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
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
    %w[abseil-cpp capstone protobuf re2].each { |dir| rm_r(buildpath/"third_party"/dir) }
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
