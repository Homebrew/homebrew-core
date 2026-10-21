class Bqlog < Formula
  desc "Cross-language logging library"
  homepage "https://github.com/Tencent/BqLog"
  url "https://github.com/Tencent/BqLog/archive/refs/tags/Release_2.7.0.tar.gz"
  sha256 "0edb9fd3ba80fd286958317848cbd10795aea9c273f88c80a6fe8903afc01de5"
  license "Apache-2.0"
  head "https://github.com/Tencent/BqLog.git", branch: "main"

  livecheck do
    url :stable
    regex(/^Release[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "877d3be7d28d983a20f6efc8cead61c0e410a324bf0d562850f5e4ffc9d64377"
    sha256 cellar: :any, arm64_tahoe:       "be9f4938bdcc1c3d8239f04aa6f98071c0ccc88778eb510f8b4fabd28ac45ff4"
    sha256 cellar: :any, arm64_sequoia:     "5a405402a0fdd7e44ed81c41a9370ae675e34c55472e28ee30391d87e6f4f4ce"
    sha256 cellar: :any, arm64_linux:       "b0582f9a74dcb2078f9c1e990a5da24a848f0fb308f28d8a2c3e1afbac3a6926"
    sha256 cellar: :any, x86_64_linux:      "b304206221d76ab8aba8cf9e59733aa83993974e1a247385766c49ea3af01f52"
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
