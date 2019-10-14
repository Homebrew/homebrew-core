class Fastmod < Formula
  desc "Fast partial replacement for the codemod tool"
  homepage "https://github.com/facebookincubator/fastmod"
  url "https://github.com/facebookincubator/fastmod/archive/v0.2.6.tar.gz"
  sha256 "b70f615e883cc6cc235b62ee15ec2ec7ef4b04618b42fb79d8ee807440f6cf3c"

  bottle do
    cellar :any_skip_relocation
    sha256 "2cda181606bdc1998ccc727dbc2f8f6eaaec5a1fb1b09f186056789ecd96b235" => :catalina
    sha256 "0c3aab08129fcffdc2f92046da56402337ea35498bc0ce06a5de94c5e0194deb" => :mojave
    sha256 "f1baa87a1abcee4adbed888b370f0528515ed2db2dd889c98b6a0b1c118fb575" => :high_sierra
    sha256 "854e92c3a2cb41ae6be702aab770ecf295e86c806e6af6f9baa770ba102d4598" => :sierra
  end

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
