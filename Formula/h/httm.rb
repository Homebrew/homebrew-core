class Httm < Formula
  desc "Interactive, file-level Time Machine-like tool for ZFS/btrfs"
  homepage "https://github.com/kimono-koans/httm"
  url "https://github.com/kimono-koans/httm/archive/refs/tags/0.37.3.tar.gz"
  sha256 "4ee9e1e910fc627ab61c008a56ab8f265cdfb1f404c8c0313905df3c82ddc141"
  license "MPL-2.0"
  head "https://github.com/kimono-koans/httm.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "7997237c2c605ff4024ab9ab4322b958d1c842744a1fc982a7253f1625c493b2"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "747d71f626c2bd1856c9d32a054a1e4afd1ff1ab7cc9d8a5591f71d3912503a7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b25662bc0a5be050690e672df043e62ab6a52c876530d7525d462efac9e9baab"
    sha256 cellar: :any_skip_relocation, sonoma:         "69e6ac9bdbeec1d83df1a32d05883fbc112a47c6c01177ce50959398ba69c546"
    sha256 cellar: :any_skip_relocation, ventura:        "9a78e80c2277f5b3cb3e22b228f682d420e2d5b85e3fdf5960943a2c398267a9"
    sha256 cellar: :any_skip_relocation, monterey:       "e634db12f1006178bac3b03ba9c60d636f2fe685ec8e2ce9df367a01d559b364"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c754fb5ba8d955e08be0d5865f873a238f366cf51a096e827084fb1d617e4eac"
  end

  depends_on "rust" => :build

  on_linux do
    depends_on "acl"
  end

  def install
    system "cargo", "install", "--features", "xattrs,acls", *std_cargo_args
    man1.install "httm.1"

    bin.install "scripts/ounce.bash" => "ounce"
    bin.install "scripts/bowie.bash" => "bowie"
    bin.install "scripts/nicotine.bash" => "nicotine"
    bin.install "scripts/equine.bash" => "equine"
  end

  test do
    touch testpath/"foo"
    assert_equal "Error: httm could not find any valid datasets on the system.",
      shell_output("#{bin}/httm #{testpath}/foo 2>&1", 1).strip
    assert_equal "httm #{version}", shell_output("#{bin}/httm --version").strip
  end
end
