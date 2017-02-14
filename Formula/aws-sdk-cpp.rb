class AwsSdkCpp < Formula
  desc "AWS SDK for C++"
  homepage "https://github.com/aws/aws-sdk-cpp"
  url "https://github.com/aws/aws-sdk-cpp/archive/1.0.66.tar.gz"
  sha256 "e5d7104baa9821a0089eb58da78c53e2c15097490fe9620fbeb791f7ea5e4647"
  head "https://github.com/aws/aws-sdk-cpp.git"

  bottle do
    cellar :any
    sha256 "658a5f1e0cfa6dc0a4c3d7b3024925f87283a8106882f1d72a1981be6082ad6a" => :sierra
    sha256 "118a95f4283ad11c1ade92275c7888751d203a51a2c760d23a4fcf95c0285b1f" => :el_capitan
    sha256 "f90745e20399008905d70bd7f2b4a4f1faaf308acac15409873ab9adcb1a5764" => :yosemite
  end

  option "with-static", "Build with static linking"
  option "without-http-client", "Don't include the libcurl HTTP client"

  depends_on "cmake" => :build

  # skip two text-to-speech tests that get stuck
  patch :DATA

  def install
    args = std_cmake_args
    args << "-DSTATIC_LINKING=1" if build.with? "static"
    args << "-DNO_HTTP_CLIENT=1" if build.without? "http-client"

    mkdir "build" do
      system "cmake", "..", *args
      system "make"
      system "make", "install"
    end

    lib.install Dir[lib/"mac/Release/*"].select { |f| File.file? f }
  end

  test do
    (testpath/"test.cpp").write <<-EOS.undent
      #include <aws/core/Version.h>
      #include <iostream>

      int main() {
          std::cout << Aws::Version::GetVersionString() << std::endl;
          return 0;
      }
    EOS
    system ENV.cxx, "test.cpp", "-o", "test", "-laws-cpp-sdk-core"
    system "./test"
  end
end

__END__
diff --git a/aws-cpp-sdk-text-to-speech-tests/TextToSpeechManagerTests.cpp b/aws-cpp-sdk-text-to-speech-tests/TextToSpeechManagerTests.cpp
index f9d6bad..de22dd2 100644
--- a/aws-cpp-sdk-text-to-speech-tests/TextToSpeechManagerTests.cpp
+++ b/aws-cpp-sdk-text-to-speech-tests/TextToSpeechManagerTests.cpp
@@ -278,7 +278,7 @@ TEST(TextToSpeechManagerTests, TestDeviceListEmpty)
     TextToSpeechManager manager(pollyClient, driverFactory);
     ASSERT_EQ(0u, manager.EnumerateDevices().size());
 }
-
+/*
 TEST(TextToSpeechManagerTests, TestSynthResponseAndOutput)
 {
     auto pollyClient = Aws::MakeShared<MockPollyClient>(ALLOC_TAG);
@@ -399,4 +399,5 @@ TEST(TextToSpeechManagerTests, TestSynthRequestFailedAndNoOutput)
 
     auto buffers = driver1->GetWrittenBuffers();
     ASSERT_EQ(0u, buffers.size());   
-}
\ No newline at end of file
+}
+*/
