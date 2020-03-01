class CartridgeCli < Formula
  desc "Tarantool Cartridge command-line utility"
  homepage "https://tarantool.org/"
  url "https://github.com/tarantool/cartridge-cli/archive/1.4.0.tar.gz"
  sha256 "b5f59d1bc165cb99972943a11c59e78b5a8902f62c171667a637033f9fe3ac6a"
  head "https://github.com/tarantool/cartridge-cli.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "a4790082a90287ce8911c60c2dc9fb7a2d60dcddcd4da17f94779332c4028958" => :catalina
    sha256 "a4790082a90287ce8911c60c2dc9fb7a2d60dcddcd4da17f94779332c4028958" => :mojave
    sha256 "a4790082a90287ce8911c60c2dc9fb7a2d60dcddcd4da17f94779332c4028958" => :high_sierra
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
