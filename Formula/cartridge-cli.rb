class CartridgeCli < Formula
  desc "Tarantool Cartridge command-line utility"
  homepage "https://tarantool.org/"
  url "https://github.com/tarantool/cartridge-cli/archive/1.4.2.tar.gz"
  sha256 "d698506da5c4b8c3ef67fa54b8c75b5c9d9d338696b7c43deb9b1840d3f0c3a2"
  head "https://github.com/tarantool/cartridge-cli.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "023a5a02dd786d18587dca83115643772257463cd2886c7fd90dbafe7a0773af" => :catalina
    sha256 "023a5a02dd786d18587dca83115643772257463cd2886c7fd90dbafe7a0773af" => :mojave
    sha256 "023a5a02dd786d18587dca83115643772257463cd2886c7fd90dbafe7a0773af" => :high_sierra
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
