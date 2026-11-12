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
    sha256 cellar: :any, arm64_golden_gate: "7d1d00fd71ba6fe058a7ee594503276a27ff4f05afb13a7095412c14130dca3c"
    sha256 cellar: :any, arm64_tahoe:       "d9b17dc7fd785a3b2a4a3168eb4315552253af50aed389867980dd052a7918ed"
    sha256 cellar: :any, arm64_sequoia:     "88b3fbcd4d87aaeaf8be1af851ad2eab4bdbf5c42fe5b9f355df1120832cfcbf"
    sha256 cellar: :any, arm64_linux:       "a0530a097ccaa0258a4fe476f6a701d7c91050b692a7cca686474e7c72b1cacb"
    sha256 cellar: :any, x86_64_linux:      "a5dda47c4482362ba327ff1da148dcc79dfdf010715d30b2f20247659dd6975d"
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
