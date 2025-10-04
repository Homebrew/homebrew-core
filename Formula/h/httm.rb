class Httm < Formula
  desc "Interactive, file-level Time Machine-like tool for ZFS/btrfs"
  homepage "https://github.com/kimono-koans/httm"
  url "https://github.com/kimono-koans/httm/archive/refs/tags/0.48.6.tar.gz"
  sha256 "2f1b5b40b36810e67c6b895b788daba26887112636742b88156ef6fd1dc5d80c"
  license "MPL-2.0"
  head "https://github.com/kimono-koans/httm.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5079eedc1fe09fcf3fe6cdc4a30df33e35be381fad58df2fb6eedb22e229a22f"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8cb2d1e95f26d65b6fdba101e6cd57d2d6c67b8f37c59ed813a776377f00001b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "39e70b0346197d6f670d0b3a89f1539b55fb4b8a538f4317ecd94ff57a444e67"
    sha256 cellar: :any_skip_relocation, sonoma:        "cc807bd2863ebb9bd7ff4c7ca2284dbf0aa278fb2e75e1c0cece22d99373a693"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c5a817aa6b44fd1d2a9e3632f088a5c141e5186c9e561fae1dcbc73c9feb7042"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e2283550a5f51c7d5c7637bcfabf445b506fca9d6acc9488e281e509f534ceb8"
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
