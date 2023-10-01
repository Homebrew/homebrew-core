class AwsSdkCpp < Formula
  desc "AWS SDK for C++"
  homepage "https://github.com/aws/aws-sdk-cpp"
  # aws-sdk-cpp should only be updated every 5 releases on multiples of 5
  url "https://github.com/aws/aws-sdk-cpp.git",
      tag:      "1.11.165",
      revision: "197a6dfde08071bec386518eb1aa1631903d198d"
  license "Apache-2.0"
  head "https://github.com/aws/aws-sdk-cpp.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "7ab287da08c582ce095a23886423f8facff50fca62d9e15cf1a5dcae8643131d"
    sha256 cellar: :any,                 arm64_ventura:  "4c26a01a85cbfa93422ccb38438eb02ed77b7ada2fc2e4f449e4646bbafbfae6"
    sha256 cellar: :any,                 arm64_monterey: "7edf044d56420d357c0c4b3ec00d258b33c8d23af718a0cb95079888206bc1cb"
    sha256 cellar: :any,                 arm64_big_sur:  "3f1c2fce79920bf49dfb95f27a5e318647f16071c245b7ee9fa7217c577ba33c"
    sha256 cellar: :any,                 sonoma:         "dd0d0c3fcf1e7e45accf2796a22aaa2f59b3dc0c58da5a2d0a22449f1d578ba2"
    sha256 cellar: :any,                 ventura:        "d00cdfabdb9f6ad1a99577c4626d6f5f42eda656539d5e79de52bf80143147cb"
    sha256 cellar: :any,                 monterey:       "54e5e2d397fa40cdad44327565bb9249dec2cc5f02d493570fa24e99f992133d"
    sha256 cellar: :any,                 big_sur:        "9fb5fa7cddd12297f983da3c0bfa3a53463a4196ba4a30cac1203e086098c9a0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4e2cc3df1efa8500026f318731112a0caa3b5c9d5293dbf8bf375564c5aeca84"
  end

  depends_on "cmake" => :build
  uses_from_macos "curl"

  fails_with gcc: "5"

  def install
    ENV.append "LDFLAGS", "-Wl,-rpath,#{rpath}"
    # Avoid OOM failure on Github runner
    ENV.deparallelize if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"].present?

    system "cmake", "-S", ".", "-B", "build", *std_cmake_args, "-DENABLE_TESTING=OFF"
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

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
    system ENV.cxx, "-std=c++11", "test.cpp", "-L#{lib}", "-laws-cpp-sdk-core", "-o", "test"
    system "./test"
  end
end
