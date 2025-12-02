class Drogon < Formula
  desc "Modern C++ web application framework"
  homepage "https://drogon.org"
  # pull from git tag to get submodules
  url "https://github.com/drogonframework/drogon.git",
      tag:      "v1.9.11",
      revision: "a22956b82b6b221ceeff83913c3014ce0d048555"
  license "MIT"
  head "https://github.com/drogonframework/drogon.git", branch: "master"

  bottle do
    sha256                               arm64_tahoe:   "92797d62be765b5222be947c118e84a3910a18fb6e3c73cf00df717dc8ebbd18"
    sha256                               arm64_sequoia: "59b637806180b7e5a9443091cbd70e98254b2372aa144ac1264c7e699a502919"
    sha256                               arm64_sonoma:  "fe6f23a4a2c68e263204b89729118dc41799fb8aaed7dd75c6a53913b7eea207"
    sha256                               arm64_ventura: "3145d83dfb9f8d3be0a3d93bdcac5df5184c19eb448e5a26ab724d50cd24f9cf"
    sha256                               sonoma:        "5fa607c6e5df73eb556b1e7598aa931039ce8eee4fd911cfc81a0d536798f9db"
    sha256                               ventura:       "35da5590e6144993de4570c01c52caa88f3da941b82376582273fd23c706586b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "164824b7a40e178b8f1db45d9c0ab20b6d616fb3a0e412ad837a4175561368ee"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b3cd681f4cdde59fce58c8a194c2a55ebac32205178673bc6d2ffe4ea3da3ccc"
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
