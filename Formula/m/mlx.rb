class Mlx < Formula
  include Language::Python::Virtualenv

  desc "Array framework for Apple silicon"
  homepage "https://github.com/ml-explore/mlx"
  url "https://github.com/ml-explore/mlx/archive/refs/tags/v0.18.1.tar.gz"
  sha256 "6a86ccb0cb54e45bcc782ed4ca878935e64f24fbc38497f65e606e43d3280f8c"
  # Main license is MIT while `metal-cpp` resource is Apache-2.0
  license all_of: ["MIT", "Apache-2.0"]
  head "https://github.com/ml-explore/mlx.git", branch: "main"

  bottle do
    sha256 cellar: :any, arm64_sequoia: "f7ff101103bf279545eac047d541024a48e33458b9a59da57fdc0869ab147645"
    sha256 cellar: :any, arm64_sonoma:  "c5c15e6a9fe01c0aae89927cb71dd72e3ed281e66c311474d6c09275eb37d0cb"
    sha256 cellar: :any, arm64_ventura: "f83b7f2dac77b9fdc4629cf68a9df9bae4ad4b8ed08960769f487c7ccc16a848"
    sha256 cellar: :any, sonoma:        "2645899802a81eba22e5a7c5818b5d7bff24b87191fe94346e0b8bbe827fbfc7"
    sha256 cellar: :any, ventura:       "1534d48abc18af9a957b83606135f597d51f9c11adbfa731815cf59a6fd7b8e0"
  end

  depends_on "cmake" => :build
  depends_on "fmt" => :build
  depends_on "nlohmann-json" => :build
  depends_on :macos
  depends_on macos: :ventura
  depends_on "python@3.12"

  on_arm do
    depends_on xcode: ["15.0", :build] # for metal
  end

  on_intel do
    depends_on "openblas"
  end

  # https://github.com/ml-explore/mlx/blob/v#{version}/CMakeLists.txt#L91C21-L91C97
  # Included in not_a_binary_url_prefix_allowlist.json
  resource "metal-cpp" do
    on_arm do
      url "https://developer.apple.com/metal/cpp/files/metal-cpp_macOS15_iOS18-beta.zip"
      sha256 "d0a7990f43c7ce666036b5649283c9965df2f19a4a41570af0617bbe93b4a6e5"
    end
  end

  # Update to GIT_TAG at https://github.com/ml-explore/mlx/blob/v#{version}/mlx/io/CMakeLists.txt#L21
  resource "gguflib" do
    url "https://github.com/antirez/gguf-tools/archive/af7d88d808a7608a33723fba067036202910acb3.tar.gz"
    sha256 "1ee2dde74a3f9506af9ad61d7638a5e87b5e891b5e36a5dd3d5f412a8ce8dd03"
  end

  # https://github.com/ml-explore/mlx/blob/v#{version}/pyproject.toml#L4
  resource "nanobind" do
    url "https://files.pythonhosted.org/packages/31/48/dea3d75657366b5a75b9d57a4e4fa7b224d98e8385f72fc7762d504533df/nanobind-2.1.0-py3-none-any.whl"
    sha256 "a613a2ce750fee63f03dc8a36593be2bdc2929cb4cea56b38fafeb74b85c3a5f"
  end

  resource "setuptools" do
    url "https://files.pythonhosted.org/packages/27/cb/e754933c1ca726b0d99980612dc9da2886e76c83968c246cfb50f491a96b/setuptools-74.1.1.tar.gz"
    sha256 "2353af060c06388be1cecbf5953dcdb1f38362f87a2356c480b6b4d5fcfc8847"
  end

  def python3
    "python3.12"
  end

  def install
    ENV.append_to_cflags "-I#{Formula["nlohmann-json"].opt_include}/nlohmann"
    (buildpath/"gguflib").install resource("gguflib")

    mlx_python_dir = prefix/Language::Python.site_packages(python3)/"mlx"
    venv = virtualenv_create(buildpath/"venv", python3)
    venv.pip_install [resource("nanobind"), resource("setuptools")]
    ENV.prepend_path "PYTHONPATH", venv.site_packages

    # We bypass brew's dependency provider to set `FETCHCONTENT_TRY_FIND_PACKAGE_MODE`
    # which redirects FetchContent_Declare() to find_package() and helps find our `fmt`.
    # To re-block fetches, we use the not-recommended `FETCHCONTENT_FULLY_DISCONNECTED`.
    args = std_cmake_args + %W[
      -DCMAKE_MODULE_LINKER_FLAGS=-Wl,-rpath,#{rpath(source: mlx_python_dir)}
      -DHOMEBREW_ALLOW_FETCHCONTENT=ON
      -DFETCHCONTENT_FULLY_DISCONNECTED=ON
      -DFETCHCONTENT_TRY_FIND_PACKAGE_MODE=ALWAYS
      -DFETCHCONTENT_SOURCE_DIR_GGUFLIB=#{buildpath}/gguflib
    ]
    args << if Hardware::CPU.arm?
      (buildpath/"metal_cpp").install resource("metal-cpp")
      "-DFETCHCONTENT_SOURCE_DIR_METAL_CPP=#{buildpath}/metal_cpp"
    else
      "-DMLX_ENABLE_X64_MAC=ON"
    end

    ENV["CMAKE_ARGS"] = args.join(" ")
    ENV[build.head? ? "DEV_RELEASE" : "PYPI_RELEASE"] = "1"
    ENV["MACOSX_DEPLOYMENT_TARGET"] = "#{MacOS.version.major}.#{MacOS.version.minor.to_i}"

    system python3, "-m", "pip", "install", *std_pip_args, "."
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <cassert>

      #include <mlx/mlx.h>

      int main() {
        mlx::core::array x({1.0f, 2.0f, 3.0f, 4.0f}, {2, 2});
        mlx::core::array y = mlx::core::ones({2, 2});
        mlx::core::array z = mlx::core::add(x, y);
        mlx::core::eval(z);
        assert(z.dtype() == mlx::core::float32);
        assert(z.shape(0) == 2);
        assert(z.shape(1) == 2);
        assert(z.data<float>()[0] == 2.0f);
        assert(z.data<float>()[1] == 3.0f);
        assert(z.data<float>()[2] == 4.0f);
        assert(z.data<float>()[3] == 5.0f);
      }
    EOS
    system ENV.cxx, "test.cpp", "-std=c++17",
                    "-I#{include}", "-L#{lib}", "-lmlx",
                    "-o", "test"
    system "./test"

    (testpath/"test.py").write <<~EOS
      import mlx.core as mx
      x = mx.array(0.0)
      assert mx.cos(x) == 1.0
    EOS
    system python3, "test.py"
  end
end
