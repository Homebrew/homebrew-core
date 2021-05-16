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
  depends_on "six" => :build
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

  # These resources are needed to install protoc_gen_mavsdk, which we use to regenerate protobuf headers.
  # This is needed when brewed protobuf is newer than upstream's vendored protobuf.
  resource "Jinja2" do
    url "https://files.pythonhosted.org/packages/7a/0c/23cbcf515b5394e9f59a3e6629f26e1142b92d474ee0725a26aa5a3bcf76/Jinja2-3.0.0.tar.gz"
    sha256 "ea8d7dd814ce9df6de6a761ec7f1cac98afe305b8cdc4aaae4e114b8d8ce24c5"
  end

  resource "MarkupSafe" do
    url "https://files.pythonhosted.org/packages/67/6a/5b3ed5c122e20c33d2562df06faf895a6b91b0a6b96a4626440ffe1d5c8e/MarkupSafe-2.0.0.tar.gz"
    sha256 "4fae0677f712ee090721d8b17f412f1cbceefbf0dc180fe91bab3232f38b4527"
  end

  # Upstream only provides a wheel. This is needed only for the build.
  resource "protoc_gen_mavsdk" do
    url "https://files.pythonhosted.org/packages/da/91/96d4bde10cf9512250290880373fec0e1e068a9cafae96e69e90f45b2616/protoc_gen_mavsdk-1.0.1-py3-none-any.whl"
    sha256 "5ccdfadea69e2da95567a8aa1925bdb2d34697def2ce1d5835b596c97abcc1ac"
  end

  def install
    # Fix generator script to use brewed deps
    generator = "tools/generate_from_protos.sh"
    inreplace generator do |s|
      s.gsub!(/^(protoc_binary)=.*/, "\\1=#{Formula["protobuf"].opt_bin}/protoc")
      s.gsub!(/^(protoc_grpc_binary)=.*/, "\\1=#{Formula["grpc"].opt_bin}/grpc_cpp_plugin")
    end

    # Install protoc_gen_mavsdk deps
    venv_dir = buildpath/"bootstrap"
    venv = virtualenv_create(venv_dir, "python3")
    %w[Jinja2 MarkupSafe].each do |r|
      venv.pip_install resource(r)
    end

    # We want to install protoc_gen_mavsdk into the same venv as the other resources,
    # so let's emulate the environment created when a venv is activated.
    with_env(
      VIRTUAL_ENV: venv_dir,
      PYTHONPATH:  Formula["six"].opt_prefix/Language::Python.site_packages("python3"),
      PATH:        "#{venv_dir}/bin:#{ENV["PATH"]}",
    ) do
      buildpath.install resource("protoc_gen_mavsdk")
      system "python", "-m", "pip", "install", "-v",
             "--no-deps",
             "--no-index",
             Dir[buildpath/"protoc_gen_mavsdk-*.whl"].first
      system generator
    end

    # Keep git tree clean. This is used to generate version information.
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
