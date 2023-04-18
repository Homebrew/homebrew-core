class Enkits < Formula
  desc "C and C++ Task Scheduler for creating parallel programs"
  homepage "https://github.com/dougbinks/enkiTS"
  url "https://github.com/dougbinks/enkiTS/archive/refs/tags/v1.11.tar.gz"
  sha256 "b57a782a6a68146169d29d180d3553bfecb9f1a0e87a5159082331920e7d297e"
  license "Zlib"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "3c5711ce533d47c9a34560e89fb023a33a55d795e73c9f1ecab5d1a6a759e656"
    sha256 cellar: :any,                 arm64_monterey: "d73910b2e106da68ef13675c76e4d18a265b2c514f898a1e3ab557a5a7d52caa"
    sha256 cellar: :any,                 arm64_big_sur:  "6adefc872b396df076df8123bd17d61dd0fc1309dea9b3699df3ade05b28c578"
    sha256 cellar: :any,                 ventura:        "b8ba0283e0455e191531f33ac60dab001f312386defc0d182cda14b062930530"
    sha256 cellar: :any,                 monterey:       "cfd9a6e5f1c88e091ae948867231254e177bbce5c04acc48a05117dd16ff9ea8"
    sha256 cellar: :any,                 big_sur:        "d8a9e68c02f80beb48beb2f8b39bf12bebb5077682cc623fa25244ce9ca0364f"
    sha256 cellar: :any,                 catalina:       "675a3d006f1afd2efdcb396b178160fbfa64a40799e12d5a58364d6fa468cff7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fb5764d88d00d8df8970a0253f177b70a4d11535dfcf87a8f98a984cc81d0b1a"
  end

  depends_on "cmake" => :build

  def install
    args = std_cmake_args + %w[
      -DENKITS_BUILD_EXAMPLES=OFF
      -DENKITS_INSTALL=ON
      -DENKITS_BUILD_SHARED=ON
    ]
    system "cmake", "-S", ".", "-B", "build", *args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
    lib.install_symlink "#{lib}/enkiTS/#{shared_library("libenkiTS")}"
    pkgshare.install "example"
  end

  test do
    system ENV.cxx, pkgshare/"example/PinnedTask.cpp",
      "-std=c++11", "-I#{include}/enkiTS", "-L#{lib}", "-lenkiTS", "-o", "example"
    output = shell_output("./example")
    assert_match("This will run on the main thread", output)
    assert_match(/This could run on any thread, currently thread \d/, output)
  end
end
