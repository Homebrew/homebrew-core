class Corrosion < Formula
  desc "Easy Rust and C/C++ Integration"
  homepage "https://github.com/corrosion-rs/corrosion"
  url "https://github.com/corrosion-rs/corrosion/archive/refs/tags/v0.6.0.tar.gz"
  sha256 "0b53fe8ec121391890fdded39cd306ef18b853b49b60b81789aee66ccf27f789"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7c5bc559b3ecd1f9752b8e07be4aad0524da03fd043bab1175e720f394c37ed5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cfedd140b9fb34e85f366091f46d451d5b88f376fcddac256e951c6f3d150099"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "60a05a1d646fa280a6bc59feaada9e798318d85ddba6bc647ced2b349f524d19"
    sha256 cellar: :any_skip_relocation, sonoma:        "f9741e2db706589db632769e35b2dc8fb8d5916b7f5f87a8e5386d0db8b38040"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9ab68a76b45ea215ddc367cdff4f927cba9898163a75be9705e9b8f8797540d8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9b0b48407fb24aa963874ac7e4fc1906e7276b8ef9c1bd50a33b6907cbef244b"
  end

  depends_on "cmake" => [:build, :test]
  depends_on "rust" => [:build, :test]

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
    pkgshare.install "test"
  end

  test do
    cp_r pkgshare/"test/rust2cpp/rust2cpp/.", testpath
    inreplace "CMakeLists.txt", "include(../../test_header.cmake)", "find_package(Corrosion REQUIRED)"

    system "cmake", "-S", ".", "-B", "build"
    system "cmake", "--build", "build"

    assert_match "Hello, Cpp! I'm Rust!", shell_output("./build/cpp-exe")
  end
end
