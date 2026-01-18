class Httm < Formula
  desc "Interactive, file-level Time Machine-like tool for ZFS/btrfs"
  homepage "https://github.com/kimono-koans/httm"
  url "https://github.com/kimono-koans/httm/archive/refs/tags/0.49.9.tar.gz"
  sha256 "c9d24d296942569408fe5a625a0fbb8d833ffd7d43d56532396d7dfad3033f80"
  license "MPL-2.0"
  head "https://github.com/kimono-koans/httm.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "08a10782768d68b15eef56e3818fe93920c79c1730388c641d2b9a52c417d407"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "116dd30cbeef177bae5dd044704bddc865e614a85bb1ac0ebf5e8541a3381faf"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c641ecc94b07cfa7a42b19bea9333d152f05ab7fe4ccbd0729ffb7f31f989417"
    sha256 cellar: :any_skip_relocation, sonoma:        "24eab643a38917fa113c2f2936ae34545ae6a177052beff6c228b2a91d371172"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "755cb3101755824614938e4163569c460a63f7e742e06dec7941f88ac1a390ba"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e4e254e917848d604518a8a4a7302b331e938a31944755f95ff2afa2114b75dc"
  end

  depends_on "rust" => :build

  on_linux do
    depends_on "acl"
  end

  conflicts_with "nicotine-plus", because: "both install `nicotine` binaries"

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
    assert_equal "ERROR: httm could not find any valid datasets on the system.",
      shell_output("#{bin}/httm #{testpath}/foo 2>&1", 1).strip
    assert_equal "httm #{version}", shell_output("#{bin}/httm --version").strip
  end
end
