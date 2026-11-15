class Bqlog < Formula
  desc "Cross-language logging library"
  homepage "https://github.com/Tencent/BqLog"
  url "https://github.com/Tencent/BqLog/archive/refs/tags/Release_2.8.0.tar.gz"
  sha256 "b5a694fe5e4f3e1bfa3d7f908f8604aeda83386ac515679bb9560a7e702a3ad9"
  license "Apache-2.0"
  head "https://github.com/Tencent/BqLog.git", branch: "main"

  livecheck do
    url :stable
    regex(/^Release[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "4c803b1c48acd426a4b433145ee9d9b687c4deeadc5f59dec9057afe94621894"
    sha256 cellar: :any, arm64_tahoe:       "16450e88c860361e2a290ec96fe504e56017a7aad53c06c3a27aa8fbcb596b4b"
    sha256 cellar: :any, arm64_sequoia:     "e9c3ab9fad92df5c2b4a0cedb5077577ae963011897f9560d4fb5d1be64f74a4"
    sha256 cellar: :any, arm64_linux:       "138fd6b301ec0a7e75a521b86fc3f3c49ea8adcf3ac491ec7ba30f75af123257"
    sha256 cellar: :any, x86_64_linux:      "e98a3f5418116ac50e5578865f3a519dec36c61bca964c3cb406c1815c207da6"
  end

  depends_on "cmake" => :build

  deny_network_access!

  def install
    args = %w[-DBUILD_LIB_TYPE=both -DBQ_WERROR=OFF]
    # Build for the native architecture instead of upstream's universal default
    args << "-DCMAKE_OSX_ARCHITECTURES=#{Hardware::CPU.arch}" if OS.mac?

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    # Each tool installs another copy of the library's docs directory
    rm_r share.glob("doc/BqLog_*/docs")
  end

  test do
    (testpath/"test.cpp").write <<~'CPP'
      #include <bq_log/bq_log.h>

      int main() {
        bq::log log = bq::log::create_log("test",
          "appenders_config.file.type=compressed_file\n"
          "appenders_config.file.file_name=log/test\n"
          "appenders_config.file.levels=[all]");
        if (!log.is_valid()) return 1;
        log.info("Hello Homebrew!");
        log.force_flush();
        return 0;
      }
    CPP
    system ENV.cxx, "test.cpp", "-std=c++17", "-I#{include}", "-L#{lib}", "-lBqLog", "-Wl,-rpath,#{lib}", "-o", "test"
    system "./test"

    log_file = testpath.glob("log/test_*.logcompr").first
    assert_match "Hello Homebrew!", shell_output("#{bin}/BqLog_LogDecoder #{log_file}")
  end
end
