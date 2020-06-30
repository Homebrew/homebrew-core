class CartridgeCli < Formula
  desc "Tarantool Cartridge command-line utility"
  homepage "https://tarantool.org/"
  url "https://github.com/tarantool/cartridge-cli/archive/1.8.3.tar.gz"
  sha256 "3666214317002031127440d73248e56015c5f26f6212bed7ba8f56999d442ea6"
  head "https://github.com/tarantool/cartridge-cli.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "7d3487e6711821cb7324ea6b80a1360c5b8d6ccbbb4e5067275e6bb408282c0f" => :catalina
    sha256 "7d3487e6711821cb7324ea6b80a1360c5b8d6ccbbb4e5067275e6bb408282c0f" => :mojave
    sha256 "7d3487e6711821cb7324ea6b80a1360c5b8d6ccbbb4e5067275e6bb408282c0f" => :high_sierra
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
