class Bloaty < Formula
  desc "Size profiler for binaries"
  homepage "https://github.com/google/bloaty"
  url "https://github.com/google/bloaty/releases/download/v1.1/bloaty-1.1.tar.bz2"
  sha256 "a308d8369d5812aba45982e55e7c3db2ea4780b7496a5455792fb3dcba9abd6f"
  license "Apache-2.0"
  revision 31

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "8e520bcf47723346213398840f54204bbdb653a36098c6e3914baad853f3c7d9"
    sha256 cellar: :any,                 arm64_sonoma:  "74e520ed34f0fb12de1c72075b07b3a4c47ce93deab67b97fbcb5c5ab2972d87"
    sha256 cellar: :any,                 arm64_ventura: "57f887b37907a95c82d9d8e26380d0787f6a6b272441ab8895dcc87521254c82"
    sha256 cellar: :any,                 sonoma:        "59a926268747171e179dc9e7a5c807b09bdf90ab3d5b0d8983dd4fc4e7070a57"
    sha256 cellar: :any,                 ventura:       "97d54acf39bfde90e558b6416721550cb752f5222f093100739d64fd25c10c1f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "95b72acc5339745cb357f6d6d85c3f4c56bdd5746cb3fdbce1b77dc0eb03b7f0"
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
