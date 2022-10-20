class Fastmod < Formula
  desc "Fast partial replacement for the codemod tool"
  homepage "https://github.com/facebookincubator/fastmod"
  url "https://github.com/facebookincubator/fastmod/archive/v0.4.3.tar.gz"
  sha256 "0c00d7e839caf123c97822542d7f16e6f40267ea0c6b54ce2c868e3ae21de809"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5f7102efe62e30ee88c4c0275f3db41d4156ff4e6f4dc78b7d852ba4600a994c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7b0504899573e920f09106daff5e391d40419bb56de623d18666f1d383e6b8c6"
    sha256 cellar: :any_skip_relocation, monterey:       "a6b584a8fdf984cac4e2f850a900d0010193426402d8bcc51eacd888af101099"
    sha256 cellar: :any_skip_relocation, big_sur:        "a476a2776cfbb639898cb7b70c3e5789d786c727d89b67af2e606916fd9b9d15"
    sha256 cellar: :any_skip_relocation, catalina:       "950d5278ff21d3328e63428715ec925a9d444e997675e931e619f754b8608130"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "39207c32d3fddb1fe08b86b6c7312dcba2b59958b8b6d3c62654cbd4703b5a4b"
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
