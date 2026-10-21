class Drogon < Formula
  desc "Modern C++ web application framework"
  homepage "https://drogon.org"
  # pull from git tag to get submodules
  url "https://github.com/drogonframework/drogon.git",
      tag:      "v1.9.14",
      revision: "3aae769cc405cf5abb9d477675c6430924f02c7c"
  license "MIT"
  head "https://github.com/drogonframework/drogon.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "9a87aa794ec1b8fcefa96a03b41aafb03211f4271cbca7a784fcd2add0b7f15d"
    sha256 cellar: :any, arm64_tahoe:       "dda5b31078f592a8856318c8c526961effd0e1e9e41dc04a7ad617ac59120b2c"
    sha256 cellar: :any, arm64_sequoia:     "a682a4681c8999f5404f7d0086a4ac303df23fc53e91e66fc4b1e496622da836"
    sha256 cellar: :any, arm64_linux:       "12c49819b5aeefeb7cc6cbb9ca1d3609fe23cb22af3b42d05f1036ac90d0be07"
    sha256 cellar: :any, x86_64_linux:      "741ac3d98fa34e79878f408b17f1ecde11b089b9d9778d9d8a62a3ceb2325fcd"
  end

  depends_on "cmake" => [:build, :test]
  depends_on "brotli"
  depends_on "c-ares"
  depends_on "jsoncpp"
  depends_on "openssl@4"

  uses_from_macos "sqlite"

  on_linux do
    depends_on "util-linux"
    depends_on "zlib-ng-compat"
  end

  allow_network_access! :test

  def install
    args = ["-DBUILD_SHARED_LIBS=ON", "-DCMAKE_INSTALL_RPATH=#{rpath}"]
    args << "-DUUID_DIR=#{formula_opt_prefix("util-linux")}" if OS.linux?

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    system bin/"dg_ctl", "create", "project", "hello"
    cd "hello" do
      port = free_port
      inreplace "main.cc", "5555", port.to_s

      system "cmake", "-S", ".", "-B", "build", "-DCMAKE_PREFIX_PATH=#{formula_opt_prefix("openssl@4")}"
      system "cmake", "--build", "build"

      begin
        pid = spawn("build/hello")
        sleep 1
        result = shell_output("curl -s 127.0.0.1:#{port}")
        assert_match "<hr><center>drogon", result
      ensure
        Process.kill("SIGINT", pid)
        Process.wait(pid)
      end
    end
  end
end
