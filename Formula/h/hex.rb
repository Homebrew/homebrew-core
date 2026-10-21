class Hex < Formula
  desc "Futuristic take on hexdump"
  homepage "https://github.com/sitkevij/hex"
  url "https://github.com/sitkevij/hex/archive/refs/tags/v0.7.1.tar.gz"
  sha256 "32a3c45897480226fa21eafed2aab3ad4601aa21707bde314a4301fd1370b90e"
  license "MIT"
  head "https://github.com/sitkevij/hex.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "0baa03500a069640bdee24772326f6d885310fd0dc8099716da9a1ee0071c04d"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "bab058dfb31d93b52b4bde9f8908f2c7e07098d17b00f3bdfcc39231390d8b04"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "a094e50486bc6049bde40d00c89d14cbcc9b4a2b3fb4009f7fb46ee743385654"
    sha256 cellar: :any,                 arm64_linux:       "7c1d2349449b000fb3211315da7206757b90cd9167a5ee5c53eda6f3aa4e1ebd"
    sha256 cellar: :any,                 x86_64_linux:      "ee8e03fd5b0928d9ae293edf1a3614c1b7fe694e3df378f788aee1926c9ad127"
  end

  depends_on "rust" => :build

  conflicts_with "evil-helix", because: "both install `hx` binaries"
  conflicts_with "helix", because: "both install `hx` binaries"

  deny_network_access!

  def fetch
    system "cargo", "fetch", *std_cargo_fetch_args
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    (testpath/"tiny.txt").write("il")
    output = shell_output("#{bin}/hx tiny.txt")
    assert_match "0x000000: 0x69 0x6c", output

    output = shell_output("#{bin}/hx -ar -c8 tiny.txt")
    expected = <<~EOS
      let ARRAY: [u8; 2] = [
          0x69, 0x6c
      ];
    EOS
    assert_equal expected, output

    assert_match "hx #{version}", shell_output("#{bin}/hx --version")
  end
end
