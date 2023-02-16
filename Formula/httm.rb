class Httm < Formula
  desc "Interactive, file-level Time Machine-like tool for ZFS/btrfs"
  homepage "https://github.com/kimono-koans/httm"
  url "https://github.com/kimono-koans/httm/archive/refs/tags/0.21.3.tar.gz"
  sha256 "28836e475eeb3c4f69b550df36b73268fd781b79a59e1c07ad4434848959433b"
  license "MPL-2.0"
  head "https://github.com/kimono-koans/httm.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c81c3cad978d914f36f4d1ac70c2158f15089800cc87593d6943f28e264b5c39"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d2a494f111bb8334e2fd00cf32961e6a406311b7d5140b8f7ce7089a1178af18"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d5774e36b225c3b54bc0ad5c2cdefb9bd1607bd7e040e6c0c058f0e173f271ad"
    sha256 cellar: :any_skip_relocation, ventura:        "5f7f81e3bc74c6ae98dceb6ecf2b041c8231aaa022c667ee50c5e788bb9957cf"
    sha256 cellar: :any_skip_relocation, monterey:       "2fa0a1b81e7d7f2d272b7bc2f34861a9b58fce4ad4b66c083b418bcec877864d"
    sha256 cellar: :any_skip_relocation, big_sur:        "21a576082f42fe96417400caf359135eefd985ec2a9bc53cac6c186e9da26fd4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "97e22ed4ccd5164679b5dbe7f247c5a9dbab7ec5831e5746ad66f3b55653a28c"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
    man1.install "httm.1"
  end

  test do
    touch testpath/"foo"
    assert_equal "Error: httm could not find any valid datasets on the system.",
      shell_output("#{bin}/httm #{testpath}/foo 2>&1", 1).strip
    assert_equal "httm #{version}", shell_output("#{bin}/httm --version").strip
  end
end
