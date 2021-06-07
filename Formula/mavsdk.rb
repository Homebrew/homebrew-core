class Mavsdk < Formula
  include Language::Python::Virtualenv

  desc "API and library for MAVLink compatible systems written in C++17"
  homepage "https://mavsdk.mavlink.io"
  url "https://github.com/mavlink/MAVSDK.git",
      tag:      "v0.40.0",
      revision: "b0514e3fe84b035005e0ad40655f24914e5df57a"
  license "BSD-3-Clause"
  revision 3

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_big_sur: "e4036546ad0eafcfe8395b56bd7736c29853f3bec7311724afbcb30aa6a4d779"
    sha256 cellar: :any, big_sur:       "4b9bb17e054b199adc5231eb408d7e6999acc2f33027d2493b128d1b99eedb25"
    sha256 cellar: :any, catalina:      "931e1885bc91841ab304916891b450fa86e4c6f774c555a410e1ee005ec7068a"
    sha256 cellar: :any, mojave:        "40fd9622cc11e0470dbccd9bf7d4819e24418bd0adc94468b6495bb5826903c7"
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

  fails_with :clang do
    build 1100
    cause <<-EOS
      Undefined symbols for architecture x86_64:
        "std::__1::__fs::filesystem::__status(std::__1::__fs::filesystem::path const&, std::__1::error_code*)"
    EOS
  end

  # To update the resources, use homebrew-pypi-poet on the PyPI package `protoc-gen-mavsdk`.
  # These resources are needed to install protoc-gen-mavsdk, which we use to regenerate protobuf headers.
  # This is needed when brewed protobuf is newer than upstream's vendored protobuf.
  resource "Jinja2" do
    url "https://files.pythonhosted.org/packages/7a/0c/23cbcf515b5394e9f59a3e6629f26e1142b92d474ee0725a26aa5a3bcf76/Jinja2-3.0.0.tar.gz"
    sha256 "ea8d7dd814ce9df6de6a761ec7f1cac98afe305b8cdc4aaae4e114b8d8ce24c5"
  end

  resource "MarkupSafe" do
    url "https://files.pythonhosted.org/packages/67/6a/5b3ed5c122e20c33d2562df06faf895a6b91b0a6b96a4626440ffe1d5c8e/MarkupSafe-2.0.0.tar.gz"
    sha256 "4fae0677f712ee090721d8b17f412f1cbceefbf0dc180fe91bab3232f38b4527"
  end

  # Fix generate_from_protos.sh to use brewed deps
  # https://github.com/mavlink/MAVSDK/pull/1438
  patch do
    url "https://github.com/mavlink/MAVSDK/commit/09b6c09ffcddde395f9b186c6766f417e2e265b3.patch?full_index=1"
    sha256 "773720629fc75be9477aca395ceb83094f96f19422924802ccd5df7c28edc932"
  end

  def install
    on_macos do
      ENV.llvm_clang if DevelopmentTools.clang_build_version <= 1100
    end

    # Install protoc-gen-mavsdk deps
    venv_dir = buildpath/"bootstrap"
    venv = virtualenv_create(venv_dir, "python3")
    %w[Jinja2 MarkupSafe].each do |r|
      venv.pip_install resource(r)
    end

    # Install protoc-gen-mavsdk
    venv.pip_install "proto/pb_plugins"

    # Run generator script in an emulated virtual env.
    with_env(
      VIRTUAL_ENV: venv_dir,
      PYTHONPATH:  Formula["six"].opt_prefix/Language::Python.site_packages("python3"),
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
                    "-DCMAKE_INSTALL_RPATH=#{rpath}",
                    "-H."
    system "cmake", "--build", "build/default"
    system "cmake", "--build", "build/default", "--target", "install"
  end

  test do
    # Force use of Clang on Mojave
    on_macos { ENV.clang }

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
                    "-I#{include}/mavsdk", "-L#{lib}",
                    "-lmavsdk", "-lmavsdk_info"
    system "./test"

    assert_equal "Usage: #{bin}/mavsdk_server [-h | --help]",
                 shell_output("#{bin}/mavsdk_server --help").split("\n").first
  end
end
