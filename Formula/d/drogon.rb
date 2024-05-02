class Drogon < Formula
  desc "Modern C++ web application framework"
  homepage "https://drogon.org"
  # pull from git tag to get submodules
  url "https://github.com/drogonframework/drogon.git",
      tag:      "v1.9.3",
      revision: "da7f065a6f7d0793eec7737882248a4471714707"
  license "MIT"
  head "https://github.com/drogonframework/drogon.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "619f37e33df729c046428f13cdcb1333c364c9f5a7dc4ccd89b503b882b4f1d5"
    sha256 cellar: :any,                 arm64_ventura:  "f4526c65c813a4995930134948631f30185ab2c23926ce5ed0b6dd893e65f4c1"
    sha256 cellar: :any,                 arm64_monterey: "62065f5779dd586ecd200ebd342ff29fcc98c95cb7c1f9bbe97ebc2f59e56042"
    sha256 cellar: :any,                 sonoma:         "ea17f015b03cdf5a0a025c6eef6b53da3c01a19490eccd8e2063ece63a8d7391"
    sha256 cellar: :any,                 ventura:        "89b7f098b26a8a07cb2f604eecfe3aec35a115f026383cd9c28754357d088eb9"
    sha256 cellar: :any,                 monterey:       "a96b396563d4b750818b4dc277507996e835da67fb2eb98bbd3fd374e3ba3d70"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c57157837a6709c7afd97ab301be62a00b90bd54de8b9888ace6e32eb10afc6e"
  end

  depends_on "cmake" => [:build, :test]
  depends_on "brotli"
  depends_on "c-ares"
  depends_on "jsoncpp"
  depends_on "ossp-uuid"

  uses_from_macos "zlib"

  on_linux do
    depends_on "openssl@3"
  end

  def install
    cmake_args = std_cmake_args
    if OS.linux?
      cmake_args << "-DUUID_LIBRARIES=uuid"
      cmake_args << "-DUUID_INCLUDE_DIRS=#{Formula["ossp-uuid"].opt_include}/ossp"
    end

    system "cmake", "-B", "build", *cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    system bin/"dg_ctl", "create", "project", "hello"
    cd "hello" do
      port = free_port
      inreplace "main.cc", "5555", port.to_s

      cmake_args = []
      if OS.linux?
        cmake_args << "-DUUID_LIBRARIES=uuid"
        cmake_args << "-DUUID_INCLUDE_DIRS=#{Formula["ossp-uuid"].opt_include}/ossp"
      end

      system "cmake", "-B", "build", *cmake_args
      system "cmake", "--build", "build"

      begin
        pid = fork { exec "build/hello" }
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
