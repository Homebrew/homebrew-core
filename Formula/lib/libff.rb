class Libff < Formula
  desc "C++ library for Finite Fields and Elliptic Curves"
  homepage "https://github.com/scipr-lab/libff"
  # pull from git tag to get submodules
  url "https://github.com/scipr-lab/libff.git",
      tag:      "v0.2.1",
      revision: "5835b8c59d4029249645cf551f417608c48f2770"
  license "MIT"

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:    "db4d97e98593d209602d684828214f50938db098fc7abae7ddc562dd86bf49ec"
    sha256 cellar: :any,                 arm64_sequoia:  "2dfacbd13db9702a3a458660201374cff23f4c7fd509585410cb0dd937214f28"
    sha256 cellar: :any,                 arm64_sonoma:   "b0d7b1dc5eff5d62a517a534be42b362918f51d64cca55a13579d445fcbaec49"
    sha256 cellar: :any,                 arm64_ventura:  "12665fa3a1821e160992a72a91c67861ffd18fcc10bf255c20188474ec8785ac"
    sha256 cellar: :any,                 arm64_monterey: "3f8fff685a6b4b00cb5dc78dad9927be27c22cfdbde465e1d7f49c08ea6a9d56"
    sha256 cellar: :any,                 arm64_big_sur:  "183ad3fd1bb600316578dc051b250a02c803b03ee43af471b3ea3bac249af0d5"
    sha256 cellar: :any,                 sonoma:         "9a90009291176dfd59e1e73c15d069663e72a477fcb2f51b09867c8cf45593c1"
    sha256 cellar: :any,                 ventura:        "b42e23e8c807c75ff7825ba73a348a3c94e6d4d31682da30377b237ad99c5e8d"
    sha256 cellar: :any,                 monterey:       "7e92d770effa52f27d690e55981eb4bbe164ab9266573b1554ae7efbf1870167"
    sha256 cellar: :any,                 big_sur:        "5c89ae786b7d9f035e65ca4a47a0f0008511a0ba701a2659c1194c2f55157507"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "9339a1479a02fdbdd670479385040323050ada9e6022e4d4be3b167b8a477cac"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e0c274f4e83f703347f24d6c6c487224b19c72eb4f199daecfbb6c794380cd17"
  end

  depends_on "cmake" => :build
  depends_on "openssl@3" => :build

  depends_on "gmp"

  def install
    # bn128 is somewhat faster, but requires an x86_64 CPU
    curve = Hardware::CPU.intel? ? "BN128" : "ALT_BN128"

    # build libff dynamically. The project only builds statically by default
    inreplace "libff/CMakeLists.txt", "STATIC", "SHARED"

    args = %W[
      -DWITH_PROCPS=OFF
      -DCURVE=#{curve}
      -DOPENSSL_ROOT_DIR=#{Formula["openssl@3"].opt_prefix}
      -DCMAKE_CXX_STANDARD=17
      -DCMAKE_POSITION_INDEPENDENT_CODE=ON
    ]
    # Workaround to build with CMake 4
    args << "-DCMAKE_POLICY_VERSION_MINIMUM=3.5"

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    # FIXME: Test hangs on 14-x86_64 in GitHub Actions
    return if OS.mac? && Hardware::CPU.intel? && ENV["HOMEBREW_GITHUB_ACTIONS"]

    (testpath/"test.cpp").write <<~CPP
      #include <libff/algebra/curves/edwards/edwards_pp.hpp>

      using namespace libff;

      int main(int argc, char *argv[]) {
        edwards_pp::init_public_params();
        return 0;
      }
    CPP

    system ENV.cxx, "-std=c++17", "test.cpp", "-I#{include}", "-L#{lib}", "-lff", "-o", "test"
    system "./test"
  end
end
