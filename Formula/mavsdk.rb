class Mavsdk < Formula
  include Language::Python::Virtualenv

  desc "API and library for MAVLink compatible systems written in C++17"
  homepage "https://mavsdk.mavlink.io"
  url "https://github.com/mavlink/MAVSDK.git",
      tag:      "v0.44.0",
      revision: "ee84bd93b7e0ef802963503a34783772e31eb10e"
  license "BSD-3-Clause"
  revision 2

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "2895bd7c66f18384dae10bc22cc3b2ac9d40042f0b344a433fa18dd33d63a4b7"
    sha256 cellar: :any,                 arm64_big_sur:  "56c0c7dc9b99edd69ee4e68ea0001eb7a8a8339cdde96a9d0c9b76f16bea808c"
    sha256 cellar: :any,                 monterey:       "e3e888d16a7c099e4bc6b7d17695d018589ca1c6119190101b38cec3c385a164"
    sha256 cellar: :any,                 big_sur:        "f127b90be741cfaf87ee8276aff3c7cb59a4b593cafd25bf5f5e13ee3c19add1"
    sha256 cellar: :any,                 catalina:       "8381e3df82b00d8be78e2ce205ce76fda40fab26a6e7df3fa9c772b3cfa79477"
    sha256 cellar: :any,                 mojave:         "bf2ac852fe6d9d9e88931caa4300e276bb396ce44bc9a818db2c6491290ecdf5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d910482cbbab49766b26bba46856e76444d058eea7617c703a31ec6eddfa9428"
  end

  depends_on "cmake" => :build
  depends_on "python@3.9" => :build
  depends_on "six" => :build
  depends_on "abseil"
  depends_on "c-ares"
  depends_on "curl"
  depends_on "grpc"
  depends_on "jsoncpp"
  depends_on "openssl@1.1"
  depends_on "protobuf"
  depends_on "re2"
  depends_on "tinyxml2"

  uses_from_macos "zlib"

  on_macos do
    depends_on "llvm" if DevelopmentTools.clang_build_version <= 1100
  end

  on_linux do
    depends_on "gcc"
  end

  fails_with :clang do
    build 1100
    cause <<-EOS
      Undefined symbols for architecture x86_64:
        "std::__1::__fs::filesystem::__status(std::__1::__fs::filesystem::path const&, std::__1::error_code*)"
    EOS
  end

  fails_with gcc: "5"

  # To update the resources, use homebrew-pypi-poet on the PyPI package `protoc-gen-mavsdk`.
  # These resources are needed to install protoc-gen-mavsdk, which we use to regenerate protobuf headers.
  # This is needed when brewed protobuf is newer than upstream's vendored protobuf.
  resource "Jinja2" do
    url "https://files.pythonhosted.org/packages/39/11/8076571afd97303dfeb6e466f27187ca4970918d4b36d5326725514d3ed3/Jinja2-3.0.1.tar.gz"
    sha256 "703f484b47a6af502e743c9122595cc812b0271f661722403114f71a79d0f5a4"
  end

  resource "MarkupSafe" do
    url "https://files.pythonhosted.org/packages/bf/10/ff66fea6d1788c458663a84d88787bae15d45daa16f6b3ef33322a51fc7e/MarkupSafe-2.0.1.tar.gz"
    sha256 "594c67807fb16238b30c44bdf74f36c02cdf22d1c8cda91ef8a0ed8dabf5620a"
  end

  def install
    # Fix version being reported as `v#{version}-dirty`
    inreplace "CMakeLists.txt", "OUTPUT_VARIABLE VERSION_STR", "OUTPUT_VARIABLE VERSION_STR_IGNORED"

    ENV.llvm_clang if OS.mac? && (DevelopmentTools.clang_build_version <= 1100)

    # Install protoc-gen-mavsdk deps
    venv_dir = buildpath/"bootstrap"
    venv = virtualenv_create(venv_dir, "python3")
    venv.pip_install resources

    # Install protoc-gen-mavsdk
    venv.pip_install "proto/pb_plugins"

    # Run generator script in an emulated virtual env.
    with_env(
      VIRTUAL_ENV: venv_dir,
      PATH:        "#{venv_dir}/bin:#{ENV["PATH"]}",
    ) do
      system "tools/generate_from_protos.sh"
    end

    # Source build adapted from
    # https://mavsdk.mavlink.io/develop/en/contributing/build.html
    system "cmake", *std_cmake_args,
                    "-Bbuild/default",
                    "-DSUPERBUILD=OFF",
                    "-DBUILD_SHARED_LIBS=ON",
                    "-DBUILD_MAVSDK_SERVER=ON",
                    "-DBUILD_TESTS=OFF",
                    "-DVERSION_STR=v#{version}-#{tap.user}",
                    "-DCMAKE_INSTALL_RPATH=#{rpath}",
                    "-H."
    system "cmake", "--build", "build/default"
    system "cmake", "--build", "build/default", "--target", "install"
  end

  test do
    # Force use of Clang on Mojave
    ENV.clang if OS.mac?

    (testpath/"test.cpp").write <<~EOS
      #include <iostream>
      #include <mavsdk/mavsdk.h>
      int main() {
          mavsdk::Mavsdk mavsdk;
          std::cout << mavsdk.version() << std::endl;
          return 0;
      }
    EOS
    system ENV.cxx, "-std=c++17", testpath/"test.cpp", "-o", "test",
                    "-I#{include}", "-L#{lib}", "-lmavsdk"
    assert_match "v#{version}-#{tap.user}", shell_output("./test").chomp

    assert_equal "Usage: #{bin}/mavsdk_server [-h | --help]",
                 shell_output("#{bin}/mavsdk_server --help").split("\n").first
  end
end
