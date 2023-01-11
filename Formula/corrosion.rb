class Corrosion < Formula
  desc "Easy Rust and C/C++ Integration"
  homepage "https://github.com/corrosion-rs/corrosion"
  url "https://github.com/corrosion-rs/corrosion/archive/refs/tags/v0.3.2.tar.gz"
  sha256 "846dcf47b708e59b7149c78a5efa333eefe3678b83b8419bcef5de747fb2a3d3"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f0061ab1754e161238781caf1b93375f050f8058a4ddbe0de3e1d693fb60d95a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ee7fa0083af200ae06f006179059c2e57b4f29e1628dca5a8a93ccdb4c80a10e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3261e036ffb3bf8ea23b09957557759ffc952279b8dc8fda8959f36caab3d06d"
    sha256 cellar: :any_skip_relocation, ventura:        "f879c094efe7b2e13af6a326dd536c4344682827d20bc6f8b4b5f150cb17edf0"
    sha256 cellar: :any_skip_relocation, monterey:       "f095bf46f47a69bb1ddfd5fa842eb528c17bcd99787fe65c46695fa19a1fc2bf"
    sha256 cellar: :any_skip_relocation, big_sur:        "e35a04d7decc606a4c29ef8ec9108acfbc43883c23ba3a09587ccc506da6f069"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6adaf91f582839a6484c06b8163b25babdc5a90ab9274f514b4ffad547d5cfd5"
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
