class Fastmod < Formula
  desc "Fast partial replacement for the codemod tool"
  homepage "https://github.com/facebookincubator/fastmod"
  url "https://github.com/facebookincubator/fastmod/archive/v0.4.0.tar.gz"
  sha256 "c36786acd75944cf50b77f6f61e22cf6e6833a0647b1f3bafbc7ff5c3e2c8153"

  bottle do
    cellar :any_skip_relocation
    sha256 "274ec8fcf9eec3ace63784576b6f48e801c60aa0d87911c652ade74e918c04bd" => :catalina
    sha256 "4ded8ec0f1c13f363620f02098fd6b699cf8280cc4852f6006b85a6ac90e4555" => :mojave
    sha256 "03753429f472a6c12ead72534ee006c93da7d0da865c2bc393c655a9670b0dbc" => :high_sierra
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", "--locked", "--root", prefix, "--path", "."
  end

  test do
    (testpath/"input.txt").write("Hello, World!")
    system bin/"fastmod", "-d", testpath, "--accept-all", "World", "fastmod"
    assert_equal "Hello, fastmod!", (testpath/"input.txt").read
  end
end
