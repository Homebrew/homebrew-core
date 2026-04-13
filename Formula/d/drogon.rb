class Drogon < Formula
  desc "Modern C++ web application framework"
  homepage "https://drogon.org"
  # pull from git tag to get submodules
  url "https://github.com/drogonframework/drogon.git",
      tag:      "v1.9.12",
      revision: "89aca8c7993c8194f2c109c1d06a3b45bf363d5d"
  license "MIT"
  head "https://github.com/drogonframework/drogon.git", branch: "master"

  bottle do
    rebuild 1
    sha256                               arm64_tahoe:   "e54d554cd89483fea3b1033aa7a8c0142b8dd0a7f6e96fe99851c0250f9a103c"
    sha256                               arm64_sequoia: "a7d97d0b74b7b8bc3740fd0eaafcf93f1fe0ab72f683a28da9e3256111cb0df2"
    sha256                               arm64_sonoma:  "f02d33b2b8f47537762cd61f8ddacdb8503a4e898cd4086e6869068a5817ef79"
    sha256                               sonoma:        "a2dddfaf010e2f0040161dc6e7d6365f269fc7ef16f6b2b30cb28c972c2343ef"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "19365063e0137d2933f96c033ed5b064b14784e84ac5d65c7b2eff84c84fa3e2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4608264dbac7b1e42f24b1d12c16cf9f67a8d62a6165bae4534acebf4941e274"
  end

  depends_on "cmake" => [:build, :test]
  depends_on "brotli"
  depends_on "c-ares"
  depends_on "jsoncpp"
  depends_on "openssl@3"

  uses_from_macos "sqlite"

  on_linux do
    depends_on "util-linux"
    depends_on "zlib-ng-compat"
  end

  def install
    args = ["-DBUILD_SHARED_LIBS=ON", "-DCMAKE_INSTALL_RPATH=#{rpath}"]
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
