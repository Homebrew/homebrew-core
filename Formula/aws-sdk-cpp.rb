class AwsSdkCpp < Formula
  desc "AWS SDK for C++"
  homepage "https://github.com/aws/aws-sdk-cpp"
  # aws-sdk-cpp should only be updated every 10 releases on multiples of 10
  url "https://github.com/aws/aws-sdk-cpp.git",
      tag:      "1.9.140",
      revision: "e0e4ce21a6d6229b3193a4216720ead5f085a4a3"
  license "Apache-2.0"
  head "https://github.com/aws/aws-sdk-cpp.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "f36f84cb51ae5f30392c7ab6962704d292d538b502f27b876e2be5da1f2fa6ec"
    sha256 cellar: :any,                 arm64_big_sur:  "df473409961189a04284638b91a09f824b7a03b58891fdb077a281f76f0a12e2"
    sha256 cellar: :any,                 monterey:       "bb3af5916035179439df096d3b2eb7789b0ded644d84f73bb4cfd7e088b16839"
    sha256 cellar: :any,                 big_sur:        "d03e876036ced4237e175cf6003f5fe818c8f1c9a456d8d14c082bb72cc5782d"
    sha256 cellar: :any,                 catalina:       "02c47f85cfc437ec3278efdc327aa92c76ca0ce44e82d860d13487109f06eada"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "49948759f3c6901e3e7867977ac53f885c78a6995703ac9f4c1d85094e51457f"
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
