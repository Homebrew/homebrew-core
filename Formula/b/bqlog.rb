class Bqlog < Formula
  desc "Cross-language logging library"
  homepage "https://github.com/Tencent/BqLog"
  url "https://github.com/Tencent/BqLog/archive/refs/tags/Release_2.8.4.tar.gz"
  sha256 "2943bc9208756f717f886d69831f266b498b75c0f8be7b5203060243e16181ab"
  license "Apache-2.0"
  head "https://github.com/Tencent/BqLog.git", branch: "main"

  livecheck do
    url :stable
    regex(/^Release[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    manifest_sha256 "f2fbf22d95065dd1f098e4d762aee2bba17398dd2a352139ec119affb70a1e28"
    sha256 cellar: :any, arm64_golden_gate: "35bee8b316b128c5856f3f5d2c4f967e2de34361182d04f9f9562262bff47a78"
    sha256 cellar: :any, arm64_tahoe:       "068ad1bf05b2c36def7f012fa0111a5f976538946366c7f4235b42069f253e45"
    sha256 cellar: :any, arm64_sequoia:     "803d7c9f5081a55ef56408fa18a27b51af9c0b6ac614cdbff785eacd7d679bcf"
    sha256 cellar: :any, arm64_linux:       "506a5c91d581f83952eb7e1b243684be94ff1deee26b7a7319a8887f98ff6916"
    sha256 cellar: :any, x86_64_linux:      "a1b147b50f69c1f66861dd549b58e03972180f7333ea9e72f11741b15adf1625"
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
