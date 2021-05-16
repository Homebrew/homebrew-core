class Mavsdk < Formula
  include Language::Python::Virtualenv

  desc "API and library for MAVLink compatible systems written in C++17"
  homepage "https://mavsdk.mavlink.io"
  url "https://github.com/mavlink/MAVSDK.git",
      tag:      "v0.40.0",
      revision: "b0514e3fe84b035005e0ad40655f24914e5df57a"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_big_sur: "6fddefcfb1d1f0649767f69fab606f6b725fc1caedfc4a79cf918042f4d79fd9"
    sha256 cellar: :any, big_sur:       "d49baf8d2e0c11419ada74695d8e74f0704ee3ce967285614f569121a2577dac"
    sha256 cellar: :any, catalina:      "10cbe171310dda87a6720d190d92392acfce112721007e0c4ea01674bda04d4b"
  end

  depends_on "cmake" => :build
  depends_on "python@3.9" => :build
  depends_on "abseil"
  depends_on "c-ares"
  depends_on "curl"
  depends_on "grpc"
  depends_on "jsoncpp"
  depends_on macos: :catalina # Mojave libc++ is too old
  depends_on "openssl@1.1"
  depends_on "protobuf"
  depends_on "re2"
  depends_on "tinyxml2"

  uses_from_macos "zlib"

  def install
    generator = "tools/generate_from_protos.sh"
    inreplace generator do |s|
      s.gsub!(/^(protoc_binary)=.*/, "\\1=#{Formula["protobuf"].opt_bin}/protoc")
      s.gsub!(/^(protoc_grpc_binary)=.*/, "\\1=#{Formula["grpc"].opt_bin}/grpc_cpp_plugin")
    end

    # We need `protoc-gen-mavsdk` to bootstrap
    venv_dir = buildpath/"bootstrap"
    with_env(
      VIRTUAL_ENV: venv_dir,
      PATH:        "#{venv_dir}/bin:#{ENV["PATH"]}",
    ) do
      virtualenv_create(venv_dir, "python3")
      system venv_dir/"bin/pip", "install", "protoc-gen-mavsdk"
      system generator
    end

    # Keep tree clean
    system "git", "restore", buildpath

    # Source build adapted from
    # https://mavsdk.mavlink.io/develop/en/contributing/build.html
    system "cmake", *std_cmake_args,
                    "-Bbuild/default",
                    "-DSUPERBUILD=OFF",
                    "-DBUILD_SHARED_LIBS=ON",
                    "-DBUILD_MAVSDK_SERVER=ON",
                    "-DBUILD_TESTS=OFF",
                    "-DCMAKE_INSTALL_RPATH=#{rpath}",
                    "-H."
    system "cmake", "--build", "build/default"
    system "cmake", "--build", "build/default", "--target", "install"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <mavsdk/mavsdk.h>
      #include <mavsdk/plugins/info/info.h>
      int main() {
          mavsdk::Mavsdk mavsdk;
          mavsdk.version();
          mavsdk::System& system = mavsdk.system();
          auto info = std::make_shared<mavsdk::Info>(system);
          return 0;
      }
    EOS
    system ENV.cxx, "-std=c++17", testpath/"test.cpp", "-o", "test",
                  "-I#{include}/mavsdk",
                  "-L#{lib}",
                  "-lmavsdk",
                  "-lmavsdk_info"
    system "./test"

    assert_equal "Usage: #{bin}/mavsdk_server [-h | --help]",
                 shell_output("#{bin}/mavsdk_server --help").split("\n").first
  end
end
