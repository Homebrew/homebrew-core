class Httm < Formula
  desc "Interactive, file-level Time Machine-like tool for ZFS/btrfs"
  homepage "https://github.com/kimono-koans/httm"
  url "https://github.com/kimono-koans/httm/archive/refs/tags/0.21.0.tar.gz"
  sha256 "70ecfa7f5c5b37cc7a3fe9ad33062e46c60502cf5d00d08639a73006bf2f79cc"
  license "MPL-2.0"
  head "https://github.com/kimono-koans/httm.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b08e60784e1fb056e924d895ee0875061cbee42b7aed7fcb22fc07d702f44e7e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e048f80308d96855d5f9ec1aab944dd8436500b41a3399c23d65ec50a2931f7e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8bab8823a9b72424303cade089792d7ed00fd7a7d9cae2a28251f9f3769e4a42"
    sha256 cellar: :any_skip_relocation, ventura:        "256acd3efa262274722054a9f37366488d0dfb65064da6a757c22c693499f5ed"
    sha256 cellar: :any_skip_relocation, monterey:       "f0c71bac1c2ed1c9a26e33b717586870c03b92393d554d5f75b5e5d961ca0516"
    sha256 cellar: :any_skip_relocation, big_sur:        "92e81fdceb7fbcf3014080aa59d434133b45c1b3690bffff6091d22087cdcc63"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cc2465a449617694a54021926a914d32d121814eb52d39cfbe77a116e72b0064"
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
