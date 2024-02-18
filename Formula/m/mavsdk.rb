class Mavsdk < Formula
  include Language::Python::Virtualenv

  desc "API and library for MAVLink compatible systems written in C++17"
  homepage "https://mavsdk.mavlink.io"
  url "https://github.com/mavlink/MAVSDK.git",
      tag:      "v1.4.18",
      revision: "b87a21d9044b9385e570fe0dd3389b74a3d52c2d"
  license "BSD-3-Clause"
  revision 4

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "0da54134d08e71bcc59491fd5badbeb18f85676049f3583492ef5cdffb1e4b19"
    sha256 cellar: :any,                 arm64_ventura:  "db6ee13e4498af2075b55cb45d03f46dd759a0f75b9ea8c8efa2ae111f051f7e"
    sha256 cellar: :any,                 arm64_monterey: "1c413cbe51ada8e4be67a74543e3cde40d4971f00734392059f0d7eef8ed3150"
    sha256 cellar: :any,                 sonoma:         "4cdb72a764d1c0b37b644057327df6a8700e7bb731ad5063efa6323a4039b595"
    sha256 cellar: :any,                 ventura:        "8200557b34290f7710e7e6da70c03a64d1e9b6506a93d199f2c091ad8997a4d5"
    sha256 cellar: :any,                 monterey:       "54bfc77f202592960088418e6c2bd33917a19b25d2320f6223a124f6799a5898"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "171de6995d40ee10b740db63d0afbb9ce05f30e1ccc591e6a4c2e1d1b79b3f9e"
  end

  depends_on "cmake" => :build
  # `future` issue ref: https://github.com/PythonCharmers/python-future/issues/625
  # `pymavlink` PR ref to remove `future`: https://github.com/ArduPilot/pymavlink/pull/830
  depends_on "python@3.11" => :build # Python 3.12 blocked by imp usage in `future` used by pymavlink
  depends_on "six" => :build
  depends_on "abseil"
  depends_on "c-ares"
  depends_on "curl"
  depends_on "grpc"
  depends_on "jsoncpp"
  depends_on "openssl@3"
  depends_on "protobuf"
  depends_on "re2"
  depends_on "tinyxml2"

  uses_from_macos "zlib"

  on_macos do
    depends_on "llvm" if DevelopmentTools.clang_build_version <= 1100
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
  resource "future" do
    url "https://files.pythonhosted.org/packages/8f/2e/cf6accf7415237d6faeeebdc7832023c90e0282aa16fd3263db0eb4715ec/future-0.18.3.tar.gz"
    sha256 "34a17436ed1e96697a86f9de3d15a3b0be01d8bc8de9c1dffd59fb8234ed5307"
  end

  resource "Jinja2" do
    url "https://files.pythonhosted.org/packages/7a/ff/75c28576a1d900e87eb6335b063fab47a8ef3c8b4d88524c4bf78f670cce/Jinja2-3.1.2.tar.gz"
    sha256 "31351a702a408a9e7595a8fc6150fc3f43bb6bf7e319770cbc0db9df9437e852"
  end

  resource "MarkupSafe" do
    url "https://files.pythonhosted.org/packages/6d/7c/59a3248f411813f8ccba92a55feaac4bf360d29e2ff05ee7d8e1ef2d7dbf/MarkupSafe-2.1.3.tar.gz"
    sha256 "af598ed32d6ae86f1b747b82783958b1a4ab8f617b06fe68795c7f026abbdcad"
  end

  def install
    # Fix version being reported as `v#{version}-dirty`
    inreplace "CMakeLists.txt", "OUTPUT_VARIABLE VERSION_STR", "OUTPUT_VARIABLE VERSION_STR_IGNORED"

    ENV.llvm_clang if OS.mac? && (DevelopmentTools.clang_build_version <= 1100)

    # Install protoc-gen-mavsdk deps
    venv_dir = buildpath/"bootstrap"
    venv = virtualenv_create(venv_dir, "python3.11")
    venv.pip_install resources

    # Install protoc-gen-mavsdk
    venv.pip_install "proto/pb_plugins"

    # Run generator script in an emulated virtual env.
    with_env(
      VIRTUAL_ENV: venv_dir,
      PATH:        "#{venv_dir}/bin:#{ENV["PATH"]}",
    ) do
      system "tools/generate_from_protos.sh"

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
    end
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

    assert_equal "Usage: #{bin}/mavsdk_server [Options] [Connection URL]",
                 shell_output("#{bin}/mavsdk_server --help").split("\n").first
  end
end
