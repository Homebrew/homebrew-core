class CartridgeCli < Formula
  desc "Tarantool Cartridge command-line utility"
  homepage "https://tarantool.org/"
  url "https://github.com/tarantool/cartridge-cli/archive/1.8.1.tar.gz"
  sha256 "47c028792caf69fbfa8dd8e1c989555d09141de8cea5154ae71e8b34845f601a"
  head "https://github.com/tarantool/cartridge-cli.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "b5bb89bf54e0405bb8115ab20d10e9e88b24d6ed283e8c780c0e685f1ea3dd79" => :catalina
    sha256 "b5bb89bf54e0405bb8115ab20d10e9e88b24d6ed283e8c780c0e685f1ea3dd79" => :mojave
    sha256 "b5bb89bf54e0405bb8115ab20d10e9e88b24d6ed283e8c780c0e685f1ea3dd79" => :high_sierra
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
