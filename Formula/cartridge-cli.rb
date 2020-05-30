class CartridgeCli < Formula
  desc "Tarantool Cartridge command-line utility"
  homepage "https://tarantool.org/"
  url "https://github.com/tarantool/cartridge-cli/archive/1.8.2.tar.gz"
  sha256 "28d98427d7d2cc72232cae501c9fe37ea5a8bf726b8e6d0d226a3714d53695a7"
  head "https://github.com/tarantool/cartridge-cli.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "8e6687feeb020f55e95198693ef250a88214a383a3d81d7f548c79cf8d671458" => :catalina
    sha256 "8e6687feeb020f55e95198693ef250a88214a383a3d81d7f548c79cf8d671458" => :mojave
    sha256 "8e6687feeb020f55e95198693ef250a88214a383a3d81d7f548c79cf8d671458" => :high_sierra
  end

  depends_on "cmake" => :build
  depends_on "tarantool"

  def install
    system "cmake", ".", *std_cmake_args, "-DVERSION=#{version}"
    system "make"
    system "make", "install"
  end

  test do
    project_path = Pathname("test-project")
    project_path.rmtree if project_path.exist?
    system bin/"cartridge", "create", "--name", project_path
    assert_predicate project_path, :exist?
    assert_predicate project_path.join("init.lua"), :exist?
  end
end
