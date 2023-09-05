class Bloaty < Formula
  desc "Size profiler for binaries"
  homepage "https://github.com/google/bloaty"
  url "https://github.com/google/bloaty/releases/download/v1.1/bloaty-1.1.tar.bz2"
  sha256 "a308d8369d5812aba45982e55e7c3db2ea4780b7496a5455792fb3dcba9abd6f"
  license "Apache-2.0"
  revision 16

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "95f9748740e26fced36f511a6516716b2c55a7adaf6e195225bd1e1b7677fdea"
    sha256 cellar: :any,                 arm64_monterey: "c23b940a2607d962a3ba76e6d7eba67f5dc3f836383b381460405cf9caaac515"
    sha256 cellar: :any,                 arm64_big_sur:  "c7ee4de1a4b1571c86d67238c7e8287f412914e8f552ffec735595b068e4f107"
    sha256 cellar: :any,                 ventura:        "8ba2c32d6da01e0260301bfa764fc97f11e316e4e2930b87d9f66c8484a7414a"
    sha256 cellar: :any,                 monterey:       "f4ba31c097132f972e4edc73a88c937bb47eff148823e79908a482a026549ccd"
    sha256 cellar: :any,                 big_sur:        "20888baf5c99fa14e39a2e6510eca27779df7669a500c1e40616b4d6be81f55a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b1c2d67003cf31d70b038da0d395723e83cdb2b9006fe9349aff4b40793bb62c"
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
