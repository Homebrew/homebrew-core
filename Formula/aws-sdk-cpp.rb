class AwsSdkCpp < Formula
  desc "AWS SDK for C++"
  homepage "https://github.com/aws/aws-sdk-cpp"
  # aws-sdk-cpp should only be updated every 10 releases on multiples of 10
  url "https://github.com/aws/aws-sdk-cpp.git",
      tag:      "1.9.170",
      revision: "fb8cbebf2fd62720b65aeff841ad2950e73d8ebd"
  license "Apache-2.0"
  head "https://github.com/aws/aws-sdk-cpp.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "278a99f5def5e7a210f375637c0b9442accec3a3c1fb8318c7c6bae702f637bd"
    sha256 cellar: :any,                 arm64_big_sur:  "8a4efbc0b986cea80dcbe0c5d57191ce6f7cb7a9d99dc89ebdf3554eef4d0e18"
    sha256 cellar: :any,                 monterey:       "7e97a6348d524f2a4a1d0c5e76389fd723daacdd2fb1a72525767f0be6eb3294"
    sha256 cellar: :any,                 big_sur:        "9922eaefea2fc94d11a215476211885ab98c7a60b0827ac3bb29cdf0fdf4db32"
    sha256 cellar: :any,                 catalina:       "b32fa656275c8af177af5137a00d666eba3b315bb457fcad374e5edc5bc84954"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "55c771614c6e887a03b9568fc939a8c360b2472ff27386e6497203c7e8b826d1"
  end

  depends_on "cmake" => :build

  uses_from_macos "curl"

  on_linux do
    depends_on "gcc"
  end

  fails_with gcc: "5"

  def install
    ENV.append "LDFLAGS", "-Wl,-rpath,#{rpath}"
    mkdir "build" do
      args = %w[
        -DENABLE_TESTING=OFF
      ]
      system "cmake", "..", *std_cmake_args, *args
      system "make"
      system "make", "install"
    end

    lib.install Dir[lib/"mac/Release/*"].select { |f| File.file? f }
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <aws/core/Version.h>
      #include <iostream>

      int main() {
          std::cout << Aws::Version::GetVersionString() << std::endl;
          return 0;
      }
    EOS
    system ENV.cxx, "-std=c++11", "test.cpp", "-L#{lib}", "-laws-cpp-sdk-core",
           "-o", "test"
    system "./test"
  end
end
