class Enkits < Formula
  desc "C and C++ Task Scheduler for creating parallel programs"
  homepage "https://github.com/dougbinks/enkiTS"
  url "https://github.com/dougbinks/enkiTS/archive/refs/tags/v1.12.tar.gz"
  sha256 "8373b6199d56816bd3ba58432eae74e2ebd5afcfdffb723073cc34730b189fd5"
  license "Zlib"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "401d2242276475ba7176da65f6de0e70f767a59a1ec50239a14f9d41901e20d0"
    sha256 cellar: :any, arm64_sequoia: "df82b8c8ce8d5c0ceb55ab5e572b6f61617ba2009469e9586d6adc2b8a6a64f4"
    sha256 cellar: :any, arm64_sonoma:  "41a74d2427e5a8366243a5e9efb888da9cd5abacef5f2655236c1740f3103369"
    sha256 cellar: :any, sonoma:        "013b6c4ec41f9a2c7d3523a8d6a9db43ac743db4dd0d4b311437cb60b1fb30ed"
    sha256 cellar: :any, arm64_linux:   "c2a296ec45bee2c2794aa11ff67f3f42d06c44bb27c0a0524667f7dec957519d"
    sha256 cellar: :any, x86_64_linux:  "3f68e3934e96a041e79efc854aec8d7e41ec7ca368963008c399bded2af261ac"
  end

  depends_on "cmake" => :build

  def install
    args = %w[
      -DENKITS_BUILD_EXAMPLES=OFF
      -DENKITS_INSTALL=ON
      -DENKITS_BUILD_SHARED=ON
    ]
    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
    pkgshare.install "example"
  end

  test do
    system ENV.cxx, pkgshare/"example/PinnedTask.cpp",
      "-std=c++11", "-I#{include}/enkiTS", "-L#{lib}", "-lenkiTS", "-o", "example"
    output = shell_output("./example")
    assert_match("This will run on the main thread", output)
    assert_match(/This could run on any thread, currently thread \d/, output)
  end
end
