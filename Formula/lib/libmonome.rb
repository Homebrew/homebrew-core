class Libmonome < Formula
  desc "Library for easy interaction with monome devices"
  homepage "https://monome.org/"
  url "https://github.com/monome/libmonome/archive/refs/tags/v1.4.11.tar.gz"
  sha256 "8eff3e5fe159d2a718e578808b129a8603b45e91c54f194704c20916acf181d6"
  license "ISC"
  compatibility_version 1
  head "https://github.com/monome/libmonome.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "16f656808b0ee4c3bce0b379cdbeb0f81142b51c2239f0a0841e1203d7704232"
    sha256 cellar: :any, arm64_tahoe:       "0547048b33e2552f2fdf6e05d789027322bd2762b0479b12268b236fcffd79bd"
    sha256 cellar: :any, arm64_sequoia:     "4ee60aad29f6c05369e4d71413616349d3da7935dc98880a1da1b46027c42d31"
    sha256 cellar: :any, arm64_sonoma:      "cdcfd91a4b26147b2b53b17bcb3cb0e98320b3c489ae7d011efd8aa25c18a4e2"
    sha256 cellar: :any, arm64_linux:       "0422dda2c8a90ed1ab3ffd3414ac19326803e1c3a1a84cc49cb2927291bdc6e3"
    sha256 cellar: :any, x86_64_linux:      "cc8493ed884388b20054d0c4eb89d006bd024ab06e59050acd9b07f41211a7df"
  end

  depends_on "cmake" => [:build, :test]
  depends_on "liblo"

  uses_from_macos "python" => :build

  on_linux do
    depends_on "pkgconf" => :build
    depends_on "systemd" # for libudev
  end

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    pkgshare.install Dir["examples/*.c"]
  end

  test do
    cp pkgshare/"simple.c", "simple.c"
    (testpath/"CMakeLists.txt").write <<~EOS
      add_executable(simple ${CMAKE_CURRENT_SOURCE_DIR}/simple.c)
      target_link_libraries(simple PRIVATE monome)
    EOS

    system "cmake", "-S", ".", "-B", "build"
    system "cmake", "--build", "build"

    # assert no output and failure for missing device
    assert_equal "", shell_output("build/simple", 255)
  end
end
