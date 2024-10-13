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
    sha256 cellar: :any, arm64_sequoia: "5f5e0298961712ffa8f424593fd0d22a2a6d3f172e193a74492eb3acf5599ffe"
    sha256 cellar: :any, arm64_sonoma:  "4d44552bcaf9e498f2875f63819708ae0b2d7456a44bfb5de1803dfde6964337"
    sha256 cellar: :any, arm64_ventura: "67141b5129d4ece72e93b4d8c91e0d0064464d35c499b5fcfc50d1b62359dea8"
    sha256 cellar: :any, sonoma:        "45450229616ac9199edda2ce7a357f27f6fbbfea5824922090aa452d04d28c0c"
    sha256 cellar: :any, ventura:       "b2b6d970ca97169702bf0953794d8ab866ff5ae819aebb82bf9f2f36aa2e8494"
  end

  depends_on "cmake" => :build
  depends_on "fmt" => :build
  depends_on "nanobind" => :build
  depends_on "nlohmann-json" => :build
  depends_on "python-setuptools" => :build
  depends_on "robin-map" => :build
  depends_on :macos
  depends_on macos: :ventura
  depends_on "python@3.13"

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

  def python3
    "python3.13"
  end

  def install
    ENV.append_to_cflags "-I#{Formula["nlohmann-json"].opt_include}/nlohmann"
    (buildpath/"gguflib").install resource("gguflib")

    mlx_python_dir = prefix/Language::Python.site_packages(python3)/"mlx"

    # We bypass brew's dependency provider to set `FETCHCONTENT_TRY_FIND_PACKAGE_MODE`
    # which redirects FetchContent_Declare() to find_package() and helps find our `fmt`.
    # To re-block fetches, we use the not-recommended `FETCHCONTENT_FULLY_DISCONNECTED`.
    args = %W[
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

    ENV["CMAKE_ARGS"] = (args + std_cmake_args).join(" ")
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
