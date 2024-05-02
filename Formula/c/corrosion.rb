class Corrosion < Formula
  desc "Easy Rust and C/C++ Integration"
  homepage "https://github.com/corrosion-rs/corrosion"
  url "https://github.com/corrosion-rs/corrosion/archive/refs/tags/v0.4.9.tar.gz"
  sha256 "3346b21c4986c077988e10a19b8737a7b56f6f84ef8e800058b58d1f138e8fa9"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "96299165701c7fda8c49cd6ea73a27ce7a3f4383030dc5b823f8e335d0a48d94"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "cf52745cc8bc4eeeb685142f6e90586dc0d1e9f23c39b238ce6f69b1393e2c18"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2966e3368d4c454b99768c5418424789fb1d674b27c79b0a7347d20b4f7e60ad"
    sha256 cellar: :any_skip_relocation, sonoma:         "474265fd565c734cdb34c0665bf0d9a063186905a2ed095bb5dd9b5ae52917f1"
    sha256 cellar: :any_skip_relocation, ventura:        "68223a2c5c372caeb92d9d76a5421487e5bed728b99d4ffef4ac26250a3efc06"
    sha256 cellar: :any_skip_relocation, monterey:       "20d5ed5576f4045c374f41c45780c5aed7461c29a802141068f93e35d9a36c6a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "17f91d3c90e179d3d1a7bebe5f1736d4fbb27495c023e0055bee78dff71243d8"
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
    system "cmake", "."
    system "cmake", "--build", "."
    assert_match "Hello, Cpp! I'm Rust!", shell_output("./cpp-exe")
  end
end
