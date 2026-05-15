class Libff < Formula
  desc "C++ library for Finite Fields and Elliptic Curves"
  homepage "https://github.com/scipr-lab/libff"
  # pull from git tag to get submodules
  url "https://github.com/scipr-lab/libff.git",
      tag:      "v0.2.1",
      revision: "5835b8c59d4029249645cf551f417608c48f2770"
  license "MIT"
  revision 1

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "6d548d433ca79ddd1e4c06bd46cd8ef42f62fda7de2ccbcc801be541ee8737d1"
    sha256 cellar: :any,                 arm64_sequoia: "98d30e843fc0146a9f665ce977f9ef8fdcd1f54900f3fbeea53a1237e95ec89b"
    sha256 cellar: :any,                 arm64_sonoma:  "8bf88eba95bb1ddbdbbc33a4419deecdf57a08859bc92b41e9cbe0d279c8da12"
    sha256 cellar: :any,                 sonoma:        "09d3bf03794916e8a9c62b9f2f5e1cd837e6ce0ef9e9d77bc8a55c985edef065"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6374bbb3ccd7a5bd91375bb9c648417f187ef488e99ec079ba18cf5c2a5c271e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bd5b454571c2432cf6250d265cb780c3b4c5252f4a6b668e74d092d1e544cb6e"
  end

  depends_on "cmake" => :build
  depends_on "openssl@4" => :build

  depends_on "gmp"

  def install
    # bn128 is somewhat faster, but requires an x86_64 CPU
    curve = Hardware::CPU.intel? ? "BN128" : "ALT_BN128"

    inreplace "libff/CMakeLists.txt" do |r|
      # build libff dynamically. The project only builds statically by default
      r.gsub! "STATIC", "SHARED"
      # fix the install path of the headers.
      r.gsub! "DIRECTORY \"\"", "DIRECTORY \"${CMAKE_CURRENT_SOURCE_DIR}/\""
    end

    args = %W[
      -DWITH_PROCPS=OFF
      -DCURVE=#{curve}
      -DOPENSSL_ROOT_DIR=#{Formula["openssl@4"].opt_prefix}
      -DCMAKE_CXX_STANDARD=17
      -DCMAKE_POSITION_INDEPENDENT_CODE=ON
    ]
    # Workaround to build with CMake 4
    args << "-DCMAKE_POLICY_VERSION_MINIMUM=4.4"

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    # FIXME: Test hangs on 14-x86_64 in GitHub Actions
    return if OS.mac? && Hardware::CPU.intel? && ENV["HOMEBREW_GITHUB_ACTIONS"]

    (testpath/"test.cpp").write <<~CPP
      #include <libff/algebra/curves/alt_bn128/alt_bn128_pp.hpp>

      int main() {
          libff::alt_bn128_pp::init_public_params();
          return 0;
      }
    CPP

    system ENV.cxx, "-std=c++17", "test.cpp", "-I#{include}", "-L#{lib}", "-lff", "-o", "test"
    system "./test"
  end
end
