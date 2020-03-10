class CartridgeCli < Formula
  desc "Tarantool Cartridge command-line utility"
  homepage "https://tarantool.org/"
  url "https://github.com/tarantool/cartridge-cli/archive/1.4.1.tar.gz"
  sha256 "c227ecc7e2f7766ec1824f97e094bfcf2e7db655c7c7dbb203dd44b2342affef"
  head "https://github.com/tarantool/cartridge-cli.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "ccccde3d362ced39c24f45832bb854eeaa0a6202dac6e2818faa4e55038011ff" => :catalina
    sha256 "ccccde3d362ced39c24f45832bb854eeaa0a6202dac6e2818faa4e55038011ff" => :mojave
    sha256 "ccccde3d362ced39c24f45832bb854eeaa0a6202dac6e2818faa4e55038011ff" => :high_sierra
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
