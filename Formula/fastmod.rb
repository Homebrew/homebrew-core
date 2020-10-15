class Fastmod < Formula
  desc "Fast partial replacement for the codemod tool"
  homepage "https://github.com/facebookincubator/fastmod"
  url "https://github.com/facebookincubator/fastmod/archive/v0.4.0.tar.gz"
  sha256 "c36786acd75944cf50b77f6f61e22cf6e6833a0647b1f3bafbc7ff5c3e2c8153"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "73a07dacd6f2c4e2151a848ab7903d12eb8de8328b8f5b796d9c2faeee66e259" => :catalina
    sha256 "9154f2bf4a78aaa4a40f3c93fd73fc39a385560b996ad927e0bcd8cf363a5308" => :mojave
    sha256 "ac5cf2b03b103422096feeb6693d252058772c7e06f54442918d48750f54f7e7" => :high_sierra
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    (testpath/"input.txt").write("Hello, World!")
    system bin/"fastmod", "-d", testpath, "--accept-all", "World", "fastmod"
    assert_equal "Hello, fastmod!", (testpath/"input.txt").read
  end
end
