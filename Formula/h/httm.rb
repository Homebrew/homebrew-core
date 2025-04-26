class Httm < Formula
  desc "Interactive, file-level Time Machine-like tool for ZFS/btrfs"
  homepage "https://github.com/kimono-koans/httm"
  url "https://github.com/kimono-koans/httm/archive/refs/tags/0.46.10.tar.gz"
  sha256 "219342f84f5ce392fb3294ef0a9a009c80afc34c1287090c36e04eb594f47c15"
  license "MPL-2.0"
  head "https://github.com/kimono-koans/httm.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "431769362d49e89d1e2c4f7d4028bb0af42bdb4c231a3015095d64f60485f4be"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c53e4e9c09ceea3eff15f08c335417bbe7563e3088dc7536c7c438a9046087dc"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "fcc4e8458e3521a8ded7093a0e84aa7566d20a8eab2fce2ed994189833d7be98"
    sha256 cellar: :any_skip_relocation, sonoma:        "172001e779c58d711e41a3e71decaaa4b5140909eec5a9f6e5570b1b692ae89c"
    sha256 cellar: :any_skip_relocation, ventura:       "764ed4c0f640868315751f3aca4accc3271e986d73d4b10335c00f7786022ee9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3ae6264117e47fee5567957be8780ca4bcf345cd4782796455daf487e0e63340"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "546be27479eee401eb508a4cbb5598a0af41d7386ef4fb5ecd929c314aa28e64"
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
