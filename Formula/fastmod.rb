class Fastmod < Formula
  desc "Fast partial replacement for the codemod tool"
  homepage "https://github.com/facebookincubator/fastmod"
  url "https://github.com/facebookincubator/fastmod/archive/v0.4.3.tar.gz"
  sha256 "0c00d7e839caf123c97822542d7f16e6f40267ea0c6b54ce2c868e3ae21de809"
  license "Apache-2.0"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7df620dfd7106cf71b1aab7d95a2d7e3b4e846fb65fad55a5a5b228539db1776"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "dbdae4ac9ef2d408e51ed54b1e563090d2aaba5cd506cd6904cea7c2179f9a98"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "805f57f5a490b223d51e9608ed10ccf31c3532964f3f7414d81cc012f3430a4f"
    sha256 cellar: :any_skip_relocation, ventura:        "ff90580cee3d30a722253377a55585c2914dbe4f7a64f765a4c3079ae3c505d0"
    sha256 cellar: :any_skip_relocation, monterey:       "1397b657ee59c43478553a2b0f6e37dfd2b92e10c74986e98e405185be759797"
    sha256 cellar: :any_skip_relocation, big_sur:        "89bcdaf3bc4230e1fea6b0d92da64a333d0ade90ed5ee3a8273842c8f7e3533a"
    sha256 cellar: :any_skip_relocation, catalina:       "4bab7bc93a1d1db35666012bf7717ac61017be6437d59e7e7adce89226ab4ed9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "322cb4173cf2ff8cbdac4a81c249df2b2216c79ef340eb0692e8728295033c07"
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
