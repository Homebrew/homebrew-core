class Bloaty < Formula
  desc "Size profiler for binaries"
  homepage "https://github.com/google/bloaty"
  url "https://github.com/google/bloaty/releases/download/v1.1/bloaty-1.1.tar.bz2"
  sha256 "a308d8369d5812aba45982e55e7c3db2ea4780b7496a5455792fb3dcba9abd6f"
  license "Apache-2.0"
  revision 22

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "04e24fdc26493381b50d9a04aca3bb004238a3663643fc54024c595b7ba32313"
    sha256 cellar: :any,                 arm64_ventura:  "a10041593539630f3f4d12daf58b4ed608d41c1b83bdc63093c95bc1123ed19c"
    sha256 cellar: :any,                 arm64_monterey: "908cfeb351110a00a09886d59b963cd184af6a6e0e21493ea9cdce00954b2fea"
    sha256 cellar: :any,                 sonoma:         "d718d8d112784f143c6e3303b3af8a4d02f8d194e1db4cd6bff396423cd95a5d"
    sha256 cellar: :any,                 ventura:        "7146ab7d1e1b44e13e1134c7ab75a4d04938f47569419a2e0186f33a825a2438"
    sha256 cellar: :any,                 monterey:       "d7a4ccb65282c5e835608e315dda9cf8925c9598e8b9cc5fb20e47f9495162a6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cb3e4e135cbe978a04689dc80e22aabfaf73792add6813f372c1b5b1e3b28d3e"
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
