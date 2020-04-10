class CartridgeCli < Formula
  desc "Tarantool Cartridge command-line utility"
  homepage "https://tarantool.org/"
  url "https://github.com/tarantool/cartridge-cli/archive/1.7.0.tar.gz"
  sha256 "9bf1c9e9c811391757ba2478d6445fa3cb76a62741ef6eb3b466d507156fe454"
  head "https://github.com/tarantool/cartridge-cli.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "966901d765c55c418cede717b01ead9ad97158aeedde43c19d9306295c63a8ad" => :catalina
    sha256 "966901d765c55c418cede717b01ead9ad97158aeedde43c19d9306295c63a8ad" => :mojave
    sha256 "966901d765c55c418cede717b01ead9ad97158aeedde43c19d9306295c63a8ad" => :high_sierra
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
