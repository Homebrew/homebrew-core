class Mavsdk < Formula
  include Language::Python::Virtualenv

  desc "API and library for MAVLink compatible systems written in C++17"
  homepage "https://mavsdk.mavlink.io"
  url "https://github.com/mavlink/MAVSDK.git",
      tag:      "v1.4.18",
      revision: "b87a21d9044b9385e570fe0dd3389b74a3d52c2d"
  license "BSD-3-Clause"
  revision 5

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_sonoma:   "6ec681d8683288dd3b5dcc34e1697bb965a26f07808efcd5f5295de4c6fbc120"
    sha256 cellar: :any,                 arm64_ventura:  "5d9cbc00bdba6a838a0aae3c975d2fe175b8febda4d305fdd9869c9a21d89c70"
    sha256 cellar: :any,                 arm64_monterey: "9714b2e951b1f831d56b10ca2ec5d1aacec63b2418547dd39cc157e1a919cb94"
    sha256 cellar: :any,                 sonoma:         "92d294cc9906b8dbc7151c614a6fbc8ee3a6e0d71c08fe743b68a4ac0dc2184a"
    sha256 cellar: :any,                 ventura:        "64bb4a533fdd42e403e82975e6aef95c7f76348e27452e7ed24f025fa3b7cb79"
    sha256 cellar: :any,                 monterey:       "2514232ad28635f6d0d91d661569d449b5e4e4bf04e330be549f34ea0f484f7c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "557ffe7e9cd5e41e681bcad2f05078461574793cd0e6f40116b9dd4e6f8ee7e3"
  end

  depends_on "cmake" => :build
  depends_on "python@3.12" => :build
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
    url "https://files.pythonhosted.org/packages/a7/b2/4140c69c6a66432916b26158687e821ba631a4c9273c474343badf84d3ba/future-1.0.0.tar.gz"
    sha256 "bd2968309307861edae1458a4f8a4f3598c03be43b97521076aebf5d94c07b05"
  end

  resource "jinja2" do
    url "https://files.pythonhosted.org/packages/b2/5e/3a21abf3cd467d7876045335e681d276ac32492febe6d98ad89562d1a7e1/Jinja2-3.1.3.tar.gz"
    sha256 "ac8bd6544d4bb2c9792bf3a159e80bba8fda7f07e81bc3aed565432d5925ba90"
  end

  resource "markupsafe" do
    url "https://files.pythonhosted.org/packages/87/5b/aae44c6655f3801e81aa3eef09dbbf012431987ba564d7231722f68df02d/MarkupSafe-2.1.5.tar.gz"
    sha256 "d283d37a890ba4c1ae73ffadf8046435c76e7bc2247bbb63c00bd1a709c6544b"
  end

  def install
    # Fix version being reported as `v#{version}-dirty`
    inreplace "CMakeLists.txt", "OUTPUT_VARIABLE VERSION_STR", "OUTPUT_VARIABLE VERSION_STR_IGNORED"

    ENV.llvm_clang if OS.mac? && (DevelopmentTools.clang_build_version <= 1100)

    # Install protoc-gen-mavsdk deps
    venv_dir = buildpath/"bootstrap"
    venv = virtualenv_create(venv_dir, "python3.12")
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
