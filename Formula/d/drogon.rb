class Drogon < Formula
  desc "Modern C++ web application framework"
  homepage "https://drogon.org"
  # pull from git tag to get submodules
  url "https://github.com/drogonframework/drogon.git",
      tag:      "v1.9.1",
      revision: "637046189653ea22e6c4b13d7f47023170fa01b1"
  license "MIT"
  head "https://github.com/drogonframework/drogon.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "a5f274ce120ce13952c228554400db737f6d41e91be741602aa456744aaf8676"
    sha256 cellar: :any,                 arm64_ventura:  "00581f0919d126d6080b7cae2b6bc1224f47e54ac4053062e612fd49ce193af7"
    sha256 cellar: :any,                 arm64_monterey: "105d2ef4ae05cac2be827de8cc629a1658fadf1d29e3710560d2728595dfea2f"
    sha256 cellar: :any,                 sonoma:         "64c4d1bc4917ec61cc3974085359fcf81250208f4d046800b9355cd9a53c7bc0"
    sha256 cellar: :any,                 ventura:        "6314ee145a66cb266cdbcc0647bfa17fedbac1ac90ae13544a11037a5ce11eac"
    sha256 cellar: :any,                 monterey:       "64a8f81b99d3d571fbf9ebc0c584cf61e70323111e204b79ed42ffcdf78b3dbb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "419183bf3ddb91de34e048a4895ae267482ca56955cade6ea972aa3a3998b1d4"
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
