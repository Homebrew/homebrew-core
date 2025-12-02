class Bloaty < Formula
  desc "Size profiler for binaries"
  homepage "https://github.com/google/bloaty"
  license "Apache-2.0"
  revision 43
  head "https://github.com/google/bloaty.git", branch: "main"

  stable do
    url "https://github.com/google/bloaty/releases/download/v1.1/bloaty-1.1.tar.bz2"
    sha256 "a308d8369d5812aba45982e55e7c3db2ea4780b7496a5455792fb3dcba9abd6f"

    # Support system Abseil. Needed for Protobuf 22+.
    # Backport of: https://github.com/google/bloaty/pull/347
    patch do
      url "https://raw.githubusercontent.com/Homebrew/homebrew-core/1cf441a0/Patches/bloaty/system-abseil.patch"
      sha256 "d200e08c96985539795e13d69673ba48deadfb61a262bdf49a226863c65525a7"
    end
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "41a9df112be72d46c6f52f4ec5d146fb3ae14ca4315ed288f8ccf901796ec1a1"
    sha256 cellar: :any, arm64_sequoia: "097a74fd6b9fbb8723c04b00e9b0408f3b8f38e2c010978a9ccb68aebca8a9db"
    sha256 cellar: :any, arm64_sonoma:  "a6f8b6b048c77cad2975dfd03d3a20938233b2d59bdeeac39d5e8e74d9f4178d"
    sha256 cellar: :any, sonoma:        "e1a3cba8dc751672420cc6baf732621796d7019fc5de85e741e7b59ef493c52f"
    sha256               arm64_linux:   "381dfcef722c1d17d66d97e88d01d36b84097761c3d4af070a71bed83bfa74ae"
    sha256               x86_64_linux:  "d94ceb81ca9937546fafb8f11195431c989fad5517978458321d1cc9bd58238c"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "abseil"
  depends_on "capstone"
  depends_on "protobuf"
  depends_on "re2"

  def install
    # https://github.com/protocolbuffers/protobuf/issues/9947
    ENV.append_to_cflags "-DNDEBUG"
    # Remove vendored dependencies
    %w[abseil-cpp capstone protobuf re2].each { |dir| rm_r(buildpath/"third_party"/dir) }
    abseil_cxx_standard = 17 # Keep in sync with C++ standard in abseil.rb
    if build.stable?
      inreplace "CMakeLists.txt", "CMAKE_CXX_STANDARD 11", "CMAKE_CXX_STANDARD #{abseil_cxx_standard}"
      inreplace "CMakeLists.txt", "-std=c++11", "-std=c++17"
    end

    system "cmake", "-S", ".", "-B", "build", "-DCMAKE_CXX_STANDARD=#{abseil_cxx_standard}", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    assert_match(/100\.0%\s+(\d\.)?\d+(M|K)i\s+100\.0%\s+(\d\.)?\d+(M|K)i\s+TOTAL/,
                 shell_output("#{bin}/bloaty #{bin}/bloaty").lines.last)
  end
end
