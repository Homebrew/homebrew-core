class Httm < Formula
  desc "Interactive, file-level Time Machine-like tool for ZFS/btrfs"
  homepage "https://github.com/kimono-koans/httm"
  url "https://github.com/kimono-koans/httm/archive/refs/tags/0.19.2.tar.gz"
  sha256 "8febb9250d99884e424205705f6902eba279463ffa7ec3b9bc7337c42fff9878"
  license "MPL-2.0"
  head "https://github.com/kimono-koans/httm.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "36b1195d87454d5429054781b5c67a8e7a96408eba12d55a7dc285f30c2d965b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "44424c855ebc1d32e38ef9e2f8c00b51d9a7e6a83a6d639ad45751b5e1846d90"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "fbd88d69fdb6460258afbccb76fcf7d044aadd76e2058629d6d0b5194f8e200d"
    sha256 cellar: :any_skip_relocation, ventura:        "ea1d6b4a24ce8202a4284cd379751743ce22b0e32bbd090932f0def8012d7ee0"
    sha256 cellar: :any_skip_relocation, monterey:       "5b5169d3ba08ce12325aa3afcd8dfc41232f1970eecef84e0640c30bd63b1961"
    sha256 cellar: :any_skip_relocation, big_sur:        "8315cfd7c8a83d526c4a7ce774e4544c5338550877e435e207a28a040bd5879b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e90bd256fad656ccf38e501d41861e41fc2405f935352abc5b5a4c9430889ed2"
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
