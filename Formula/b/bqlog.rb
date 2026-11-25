class Bqlog < Formula
  desc "Cross-language logging library"
  homepage "https://github.com/Tencent/BqLog"
  url "https://github.com/Tencent/BqLog/archive/refs/tags/Release_2.8.3.tar.gz"
  sha256 "63b2f801f417e4fd21abc891b0c8cb78542d3bb54b09dbeca812400e81f4cd32"
  license "Apache-2.0"
  head "https://github.com/Tencent/BqLog.git", branch: "main"

  livecheck do
    url :stable
    regex(/^Release[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    manifest_sha256 "7c11fc5983267e8e276c07d649520812ea379087e11c5dcedf2b964b67c0df20"
    sha256 cellar: :any, arm64_golden_gate: "4ebcd527d6a735653172deb1a639e4fc278643b899dfa334f5f1b2fac408e0ca"
    sha256 cellar: :any, arm64_tahoe:       "98fad6e22a386db81b9add4b7bb1a83ad43775f105f1b33d835feb4678e73ac6"
    sha256 cellar: :any, arm64_sequoia:     "154b08857369ffb50a915d53cc14d5ccee8f0e40f1a29cd2317243725b88bcc1"
    sha256 cellar: :any, arm64_linux:       "ffdb3f423c0a14851fc7b093d3001a33ddbb306eb20aaf925e97289d6ad5314f"
    sha256 cellar: :any, x86_64_linux:      "dcf997dab1bd7a48d46592a12d479578f9060eb11fa9461fcf601d1ed3e64990"
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
