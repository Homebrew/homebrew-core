class Httm < Formula
  desc "Interactive, file-level Time Machine-like tool for ZFS/btrfs"
  homepage "https://github.com/kimono-koans/httm"
  url "https://github.com/kimono-koans/httm/archive/refs/tags/0.20.4.tar.gz"
  sha256 "7a4eff347ccc811e601ec8bf114e0ec8fadcad968c97b4239218ede5070aecb2"
  license "MPL-2.0"
  head "https://github.com/kimono-koans/httm.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d93523271cd6d8dc55836baed20b690ac1dcba5feda5e4dd0523fb859529b5c3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cc5f296cb2aedd8f3fe8648ff8ca4d5157c929436dd948c9657cc72df5631b82"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "39eee783932930ce4675f24aaecebb54312b3cb2852b293c2ced830ef3ab565f"
    sha256 cellar: :any_skip_relocation, ventura:        "8e12c527cc7a416bea1bf5f89f7edf43b39147ee2fb3e9948c4aa66844cabe80"
    sha256 cellar: :any_skip_relocation, monterey:       "9e668f20b7396a9cda0cb0c40a874bb6ded41158ab90a360cb099c93e0fa5c43"
    sha256 cellar: :any_skip_relocation, big_sur:        "ee2b7e86eea2cc7786824469cd43d749232531875b7d27d97bb78272f6c9e34c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "79f34a2175fb9306d83c1a3d9b7e2bfcb44774b3bc1a3215f75431276ab2eeaf"
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
