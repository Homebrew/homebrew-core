class Httm < Formula
  desc "Interactive, file-level Time Machine-like tool for ZFS/btrfs"
  homepage "https://github.com/kimono-koans/httm"
  url "https://github.com/kimono-koans/httm/archive/refs/tags/0.28.1.tar.gz"
  sha256 "ca89ba317b338d28b605fd508ef0a00154f37e85dba8a32cda2934420e9d6e76"
  license "MPL-2.0"
  head "https://github.com/kimono-koans/httm.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "231ae44c16307d25da7d9155e86d77e01efa5d44ea964135f5cc7681b1e38899"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0218dab8bd8de4da1829718ad59c3b940375edea234e46260805de9ce44dfe9c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "75c37e9b153d6cb379b511cfd44e85c86d7d810fa321be50969372897fe93ca3"
    sha256 cellar: :any_skip_relocation, ventura:        "5b4764129d74378ba0271d781ef92987f08c8e318f7563a0d0b12d2882eb7274"
    sha256 cellar: :any_skip_relocation, monterey:       "9704065a7d09b5eb55428bcdf4cabef79e8bb0cd0634c4c893cf2ac759a1b5c1"
    sha256 cellar: :any_skip_relocation, big_sur:        "f1530e845a8e4b40535a4a5eec89ea47b1673af4f14c8dae9849295a4d3d9f3e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "18b2078ebebbff5d88aabfbde8ec2f9f8132e9ee64b9d6925a6c1853f976080e"
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
