class Drogon < Formula
  desc "Modern C++ web application framework"
  homepage "https://drogon.org"
  # pull from git tag to get submodules
  url "https://github.com/drogonframework/drogon.git",
      tag:      "v1.9.7",
      revision: "73406d122543f548c9d07076e16880b777bfc109"
  license "MIT"
  head "https://github.com/drogonframework/drogon.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_sequoia: "2da8af2f56bc56a41a893281d27eb11026acd00a6517cf628c866105ef946b8a"
    sha256 cellar: :any,                 arm64_sonoma:  "8df95fd295e7e526a851fb68cadd287f6c215f0c54529f466bce66e4dfeceb68"
    sha256 cellar: :any,                 arm64_ventura: "a5b48f42f01f06b42f6dc7d338135483e84d26ed5ba451e7d543d12d98e8f61d"
    sha256 cellar: :any,                 sonoma:        "92e5144abb7f9320eb2e6e1415e76b13c76328cc5a6efeef7be75858fdc5627c"
    sha256 cellar: :any,                 ventura:       "fa8e59ab9a2f3c93cfdb3212fa12236918176df4f606d6d495e99106218df00f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "63db60cc4dffb45567ada02f9e29383441bf24ceeaab54835b912bc12fe2baf7"
  end

  depends_on "cmake" => [:build, :test]
  depends_on "brotli"
  depends_on "c-ares"
  depends_on "jsoncpp"
  depends_on "openssl@3"

  uses_from_macos "sqlite"
  uses_from_macos "zlib"

  on_linux do
    depends_on "util-linux"
  end

  def install
    args = []
    args << "-DUUID_DIR=#{Formula["util-linux"].opt_prefix}" if OS.linux?

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    system bin/"dg_ctl", "create", "project", "hello"
    cd "hello" do
      port = free_port
      inreplace "main.cc", "5555", port.to_s

      system "cmake", "-S", ".", "-B", "build"
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
