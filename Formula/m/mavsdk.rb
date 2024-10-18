class Mavsdk < Formula
  include Language::Python::Virtualenv

  desc "API and library for MAVLink compatible systems written in C++17"
  homepage "https://mavsdk.mavlink.io"
  url "https://github.com/mavlink/MAVSDK.git",
      tag:      "v2.12.10",
      revision: "40e4a896a239f353b0531f4729c0469b37fd0839"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "d653162ce73f77512acc923dd8183af22b43b1c0b431f0406e0fa1ef4a7bed02"
    sha256 cellar: :any,                 arm64_sonoma:  "1f3d6ecd9883f9aa007392bf6f1a4715b8b23b8e9b633c7199d77af657cc9dc7"
    sha256 cellar: :any,                 arm64_ventura: "d92acce41cad94b972cd4391a64e8ee03ac58107e8331d2d825d5523ceb869dd"
    sha256 cellar: :any,                 sonoma:        "02f61446f03089ae4baed83381a0549986cab61995780b805580e0ebbccbd4af"
    sha256 cellar: :any,                 ventura:       "d03ea2753c8d9783978eb8721e274e64b6bd688c1f92d43109c457056af34935"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a360880fe09134e53a1d6f3bbdc236c98266c8f61abc4ad09b681983e5a9dc32"
  end

  depends_on "cmake" => :build
  depends_on "maturin" => :build # For fastcrc resource
  depends_on "python-setuptools" => :build # for mavlink resource
  depends_on "python@3.13" => :build
  depends_on "rust" => :build # for maturin
  depends_on "abseil"
  depends_on "c-ares"
  depends_on "curl"
  depends_on "grpc"
  depends_on "jsoncpp"
  depends_on "openssl@3"
  depends_on "protobuf"
  depends_on "re2"
  depends_on "tinyxml2"
  depends_on "xz"

  uses_from_macos "libxml2" => :build
  uses_from_macos "libxslt" => :build
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

  # ver={version} && \
  # curl -s https://raw.githubusercontent.com/mavlink/MAVSDK/v$ver/third_party/mavlink/CMakeLists.txt && \
  # | grep 'MAVLINK_GIT_HASH'
  resource "mavlink" do
    url "https://github.com/mavlink/mavlink.git",
        revision: "f1d42e2774cae767a1c0651b0f95e3286c587257"
  end

  # For Jinja2.
  resource "flit-core" do
    url "https://files.pythonhosted.org/packages/c4/e6/c1ac50fe3eebb38a155155711e6e864e254ce4b6e17fe2429b4c4d5b9e80/flit_core-3.9.0.tar.gz"
    sha256 "72ad266176c4a3fcfab5f2930d76896059851240570ce9a98733b658cb786eba"
  end

  # For the resources below, check `pb_plugins/requirements.txt` in the `proto` submodule.
  resource "Jinja2" do
    url "https://files.pythonhosted.org/packages/ed/55/39036716d19cab0747a5020fc7e907f362fbf48c984b14e62127f7e68e5d/jinja2-3.1.4.tar.gz"
    sha256 "4a3aee7acbbe7303aede8e9648d13b8bf88a429282aa6122a993f0ac800cb369"
  end

  resource "protobuf" do
    url "https://files.pythonhosted.org/packages/19/96/1283259c25bc48a6df98fa096f66fc568b40137b93806ef5ff66a2d166b1/protobuf-3.20.1.tar.gz"
    sha256 "adc31566d027f45efe3f44eeb5b1f329da43891634d61c75a5944e9be6dd42c9"
  end

  # For resources below, see requirements.txt in pymavlink submodule of the mavlink repo.
  resource "lxml" do
    url "https://files.pythonhosted.org/packages/e7/6b/20c3a4b24751377aaa6307eb230b66701024012c29dd374999cc92983269/lxml-5.3.0.tar.gz"
    sha256 "4e109ca30d1edec1ac60cdbe341905dc3b8f55b16855e03a54aaf59e51ec8c6f"
  end

  resource "future" do
    url "https://files.pythonhosted.org/packages/a7/b2/4140c69c6a66432916b26158687e821ba631a4c9273c474343badf84d3ba/future-1.0.0.tar.gz"
    sha256 "bd2968309307861edae1458a4f8a4f3598c03be43b97521076aebf5d94c07b05"
  end

  resource "fastcrc" do
    url "https://files.pythonhosted.org/packages/00/8e/ddd7b0f1a96b17d1e359caf01e558260bb675c3de4e84477861f78a8bf22/fastcrc-0.3.0.tar.gz"
    sha256 "4e2a75359d97a59469bbcbd77513e801d3f3666a9169629578f88012c0f2d7fe"
  end

  resource "pytest" do
    url "https://files.pythonhosted.org/packages/80/1f/9d8e98e4133ffb16c90f3b405c43e38d3abb715bb5d7a63a5a684f7e46a3/pytest-7.4.4.tar.gz"
    sha256 "2cf0005922c6ace4a3e2ec8b4080eb0d9753fdc93107415332f50ce9e7994280"
  end

  resource "syrupy" do
    url "https://files.pythonhosted.org/packages/67/81/f46d234fa4ca0edcdeed973bab9acd8f8ac186537cdc850e9e84a00f61a0/syrupy-4.7.2.tar.gz"
    sha256 "ea45e099f242de1bb53018c238f408a5bb6c82007bc687aefcbeaa0e1c2e935a"
  end

  # dependencies of pytest
  resource "iniconfig" do
    url "https://files.pythonhosted.org/packages/d7/4b/cbd8e699e64a6f16ca3a8220661b5f83792b3017d0f79807cb8708d33913/iniconfig-2.0.0.tar.gz"
    sha256 "2d91e135bf72d31a410b17c16da610a82cb55f6b0477d1a902134b24a455b8b3"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/51/65/50db4dda066951078f0a96cf12f4b9ada6e4b811516bf0262c0f4f7064d4/packaging-24.1.tar.gz"
    sha256 "026ed72c8ed3fcce5bf8950572258698927fd1dbda10a5e981cdf0ac37f4f002"
  end

  resource "pluggy" do
    url "https://files.pythonhosted.org/packages/96/2d/02d4312c973c6050a18b314a5ad0b3210edb65a906f868e31c111dede4a6/pluggy-1.5.0.tar.gz"
    sha256 "2cffa88e94fdc978c4c574f15f9e59b7f4201d439195c3715ca9e2486f1d0cf1"
  end

  def install
    python3 = "python3.13"
    ENV.llvm_clang if OS.mac? && (DevelopmentTools.clang_build_version <= 1100)

    mavsdk_build_directory = buildpath/"build/default"
    ENV["PROTOC"] = Formula["protobuf"].opt_bin/"protoc"
    mavsdk_venv = virtualenv_create(mavsdk_build_directory/"pb_plugins", python3)
    mavsdk_venv.pip_install %w[flit-core Jinja2 protobuf].map { |r| resource(r) }, build_isolation: false

    # Regenerate files to support newer protobuf
    with_env(PATH: "#{mavsdk_venv.root}/bin:#{ENV["PATH"]}") do
      system "tools/generate_from_protos.sh"
    end

    resource("mavlink").stage do
      mavlink_build_directory = Pathname.pwd/"build"
      mavlink_venv = virtualenv_create(mavlink_build_directory/"pip-dependencies", python3)
      mavlink_deps = %w[lxml future fastcrc iniconfig packaging pluggy pytest syrupy]
      mavlink_venv.pip_install mavlink_deps.map { |r| resource(r) }, build_isolation: false

      with_env(PATH: "#{mavlink_venv.root}/bin:#{ENV["PATH"]}") do
        system "cmake", "-S", ".", "-B", mavlink_build_directory,
                        "-DPython_EXECUTABLE=#{mavlink_venv.root/"bin/python3"}",
                        *std_cmake_args
        system "cmake", "--build", mavlink_build_directory
        system "cmake", "--install", mavlink_build_directory
      end
      ENV.append_path "CMAKE_PREFIX_PATH", prefix
    end

    # Fix version being reported as `v#{version}-dirty`
    inreplace "CMakeLists.txt", "OUTPUT_VARIABLE VERSION_STR", "OUTPUT_VARIABLE VERSION_STR_IGNORED"

    # Source build adapted from
    # https://mavsdk.mavlink.io/develop/en/contributing/build.html
    system "cmake", "-S", ".", "-B", mavsdk_build_directory,
                    "-DSUPERBUILD=OFF",
                    "-DBUILD_SHARED_LIBS=ON",
                    "-DBUILD_MAVSDK_SERVER=ON",
                    "-DBUILD_TESTS=OFF",
                    "-DVERSION_STR=v#{version}-#{tap.user}",
                    "-DCMAKE_INSTALL_RPATH=#{rpath}",
                    *std_cmake_args
    system "cmake", "--build", mavsdk_build_directory
    system "cmake", "--install", mavsdk_build_directory
  end

  test do
    # Force use of Clang on Mojave
    ENV.clang if OS.mac?

    (testpath/"test.cpp").write <<~EOS
      #include <iostream>
      #include <mavsdk/mavsdk.h>
      using namespace mavsdk;
      int main() {
          Mavsdk mavsdk{Mavsdk::Configuration{Mavsdk::ComponentType::GroundStation}};
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
