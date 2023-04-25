class Httm < Formula
  desc "Interactive, file-level Time Machine-like tool for ZFS/btrfs"
  homepage "https://github.com/kimono-koans/httm"
  url "https://github.com/kimono-koans/httm/archive/refs/tags/0.26.1.tar.gz"
  sha256 "b88ee8608313643abd68f1e8393f6bb2e8a545345f39831ee13d4a90ffc6a9bd"
  license "MPL-2.0"
  head "https://github.com/kimono-koans/httm.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fcf8bb7ad19b5c91f3a508fa4e854cfe5690cbd484320cda4ed38e27583c79de"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c81d50397cf824cadf51c746216cb605259f547a8a2c90b016eec3a54877c234"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "fb9d44c20f46a832ca35983abbbb3c726d13cd779e68ecf15703cd5b052c59f9"
    sha256 cellar: :any_skip_relocation, ventura:        "5c04300767a4b6dcf7caf2cda9619e0fb25251c55236f5137eafd71a7c0bffae"
    sha256 cellar: :any_skip_relocation, monterey:       "ea79f398062f1e53ad2131d375e8aefab4675a7de82bd79472de71a9b09249c2"
    sha256 cellar: :any_skip_relocation, big_sur:        "8ec152d720fe00fe2972a65b0453110500b0fac1c7ade7f0c099fa8c79e6fe3d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "316c431cd0407bde0d226056fb5abc3fd9c22de33c19ce7ccc2e7d9f2ca12ae3"
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
