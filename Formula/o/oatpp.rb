class Oatpp < Formula
  desc "Light and powerful C++ web framework"
  homepage "https://oatpp.io/"
  url "https://github.com/oatpp/oatpp/archive/refs/tags/1.3.1.tar.gz"
  sha256 "9dd31f005ab0b3e8895a478d750d7dbce99e42750a147a3c42a9daecbddedd64"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "1d123435c094ef3f8505f2a0123b98f5bee8686723b01e87b7eac1124319146a"
    sha256 cellar: :any,                 arm64_sequoia: "9660efd36d9aaa939d7d03d4473cdacb0255c289105c055aa3c66e64b972790a"
    sha256 cellar: :any,                 arm64_sonoma:  "8d8f998c2c07ed45f917b85a40cc614b6820b263b8e97254d20d1149d6a91104"
    sha256 cellar: :any,                 sonoma:        "b1a74b30588c204615b87752817736ba6886e0c429228bd2c14164c6dc86bc6a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "81098264566979f91f1c984db6611ef67f766bfe74a4b0ff4fcc6df4a72e2080"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "12218676b146b645b2d7bebafa30e08fdc2a769bba634a161d4473a80384183b"
  end

  depends_on "cmake" => :build

  def install
    ENV.append "LDFLAGS", "-Wl,-rpath,#{lib}/oatpp-#{version}" if OS.linux?

    # Remove in the next release.
    # See: https://github.com/oatpp/oatpp/issues/988#issuecomment-2525575710
    inreplace "src/oatpp/core/base/Environment.hpp", "1.3.0", version.to_s

    args = %W[
      -DBUILD_SHARED_LIBS=ON
      -DCMAKE_INSTALL_RPATH=#{rpath}
      -DCMAKE_POLICY_VERSION_MINIMUM=3.5
      -DOATPP_BUILD_TESTS=OFF
    ]
    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.cpp").write <<~CPP
      #include <oatpp/web/server/HttpConnectionHandler.hpp>

      int main() {
        oatpp::base::Environment::init();
        return 0;
      }
    CPP
    flags = %W[-I#{include}/oatpp-#{version}/oatpp -L#{lib}/oatpp-#{version} -loatpp]
    flags << "-Wl,-rpath,#{lib}/oatpp-#{version}" if OS.linux?
    system ENV.cxx, "-std=c++17", "test.cpp", "-o", "test", *flags
    system "./test"
  end
end
