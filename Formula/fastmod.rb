class Fastmod < Formula
  desc "Fast partial replacement for the codemod tool"
  homepage "https://github.com/facebookincubator/fastmod"
  url "https://github.com/facebookincubator/fastmod/archive/v0.2.6.tar.gz"
  sha256 "b70f615e883cc6cc235b62ee15ec2ec7ef4b04618b42fb79d8ee807440f6cf3c"

  depends_on "rust" => :build

  def install
    system "cargo", "install", "--root", prefix, "--path", "."
  end

  test do
    (testpath/"input.txt").write("Hello, World!")
    system bin/"fastmod", "-d", testpath, "--accept-all", "World", "fastmod"
    assert_equal "Hello, fastmod!", (testpath/"input.txt").read
  end
end
