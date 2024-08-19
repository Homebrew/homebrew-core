class Grin < Formula
  desc "Minimal implementation of the Mimblewimble protocol"
  homepage "https://grin.mw/"
  url "https://github.com/mimblewimble/grin/archive/refs/tags/v5.3.2.tar.gz"
  sha256 "569b30fc1eb9ea895cb4f766cf32a759923f09cc4a9dc5eedb61f475ae25f091"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "3e5b321bcc54efc69989848712f685467873e5450f0454876a0cff7a7059bd24"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "694371cd4468f6e20e871d336294c899da3bcb6dd5336b69e9508b7f60656234"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a9eb4b86efe7b3cd9249382fb90745e15c6023754be316d69b9579174bcb2f90"
    sha256 cellar: :any_skip_relocation, sonoma:         "3b876e26b367e993930bd19ead9388789d45e0abbbca260b81d412ca591f79e4"
    sha256 cellar: :any_skip_relocation, ventura:        "f3d1c2c05e4529c7bf509d88fc7b38bedcbb82e932a63fb57d642285c334599b"
    sha256 cellar: :any_skip_relocation, monterey:       "eb6d8b4b66bf4ab38866c7e9042aefadb2baf04c8ae2f9a1862cb2f0af8b0890"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "de037587292ec33ea496fe65c3b80c2911964e9ec07084407e27d386868fb19b"
  end

  depends_on "rust" => :build

  uses_from_macos "llvm" => :build # for libclang
  uses_from_macos "ncurses"

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    system bin/"grin", "server", "config"
    assert_predicate testpath/"grin-server.toml", :exist?
  end
end
