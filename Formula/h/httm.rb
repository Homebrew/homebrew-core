class Httm < Formula
  desc "Interactive, file-level Time Machine-like tool for ZFS/btrfs"
  homepage "https://github.com/kimono-koans/httm"
  url "https://github.com/kimono-koans/httm/archive/refs/tags/0.45.0.tar.gz"
  sha256 "e137779c8acbbee639d5f70c8fd1130d3697e163bfa35ea33117d8e1cc39e7e2"
  license "MPL-2.0"
  head "https://github.com/kimono-koans/httm.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4c23c04148c44964f3c05d8a84d63195be4318e9af76370ccc2dc5160f0c7c89"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "bb3456bb60ace4b019b3ac2c07eb49ecf7d4b534d4fc3ccb22f89cab049eb83c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d44b946a01239826a7c8cf6cd7eff15908ba2bd407df9b7a56f1af9c11e8fc71"
    sha256 cellar: :any_skip_relocation, sonoma:        "91c64da6b935fcc6ec713533b86349ffc952e0d8f16bd53dd0a42ca971958632"
    sha256 cellar: :any_skip_relocation, ventura:       "2fb87df0804499d46fe291d15e06c86c29a1f7121484e31db476e11e58b94419"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "88508c3d1d2522dc24dc0ee703d3f21610bf49379e216b9ccf2c5c10f82abc19"
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
    assert_equal "Error: httm could not find any valid datasets on the system.",
      shell_output("#{bin}/httm #{testpath}/foo 2>&1", 1).strip
    assert_equal "httm #{version}", shell_output("#{bin}/httm --version").strip
  end
end
