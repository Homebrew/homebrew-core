class Bqlog < Formula
  desc "Cross-language logging library"
  homepage "https://github.com/Tencent/BqLog"
  url "https://github.com/Tencent/BqLog/archive/refs/tags/Release_2.8.1.tar.gz"
  sha256 "c5dc6310155faa7d514c5f8d00d49e35691286426ee495bf23da9bf98f24dd09"
  license "Apache-2.0"
  head "https://github.com/Tencent/BqLog.git", branch: "main"

  livecheck do
    url :stable
    regex(/^Release[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "7478940f230eba8ce6fd8cc0ea1fe6c1ecd8d601bfc1c6e5bab10f5fdd872336"
    sha256 cellar: :any, arm64_tahoe:       "4a471d7ba4deb519f649a71c21d18d22c08c0e20d2f4ea6593e92d046a78fcae"
    sha256 cellar: :any, arm64_sequoia:     "114d8e6096c5154977b00f578c2e057b712b596ea59f077cc435681aa8caaafc"
    sha256 cellar: :any, arm64_linux:       "1641b9b507adddb58a472b2f05d01119c7ce63ed389dbe2bffd7d4f412405069"
    sha256 cellar: :any, x86_64_linux:      "8ddcca9963a46c7d7eabde524ded56159a49bf236d6a0116abb930a0c5faf695"
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
