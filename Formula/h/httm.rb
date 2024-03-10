class Httm < Formula
  desc "Interactive, file-level Time Machine-like tool for ZFS/btrfs"
  homepage "https://github.com/kimono-koans/httm"
  url "https://github.com/kimono-koans/httm/archive/refs/tags/0.37.0.tar.gz"
  sha256 "5521fc900bed90e1258817c6da75e07fc0122d2a56c8c7d67304c7f1e2bd5cc4"
  license "MPL-2.0"
  head "https://github.com/kimono-koans/httm.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "cd69445416c6f0bd010c7c1fb6385a830ea4acc92e7ce0d26bf22c49441069f6"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f19adeb8d2e9def3a005656d6a3e8beb6bb45a3590258214c9ccaa155bbaca13"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2d6d27f5249c2c7f3f5cc4dbff33c8dc516475490c1ce0f9db7ab26cd50f3e21"
    sha256 cellar: :any_skip_relocation, sonoma:         "7d46fcabce00d8a3205b62574fa26dcb3d599e2812ba0d80f76bf65efd8112e7"
    sha256 cellar: :any_skip_relocation, ventura:        "b8a12a8417bfd0ce440e7587dcbb27a08576efcd8243d1d2945a9f87f8609adb"
    sha256 cellar: :any_skip_relocation, monterey:       "5fcb13485a1a7c9b0a5c90a3585ef53ebb521673329aac7c3e33f1623822533d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "11f2664e3c6a896cdadb26bf966b8e30ff9e17d3a696183107d83e6fe8b82f42"
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
