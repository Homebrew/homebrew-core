class Httm < Formula
  desc "Interactive, file-level Time Machine-like tool for ZFS/btrfs"
  homepage "https://github.com/kimono-koans/httm"
  url "https://github.com/kimono-koans/httm/archive/refs/tags/0.47.0.tar.gz"
  sha256 "bf0d12b822d13838bdad289b59dfa4bcc5436b1d6621abb8e400cd1f52e12f5d"
  license "MPL-2.0"
  head "https://github.com/kimono-koans/httm.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6503debb4c67acfb9c93359b7a727a6ae5c19f98a7bab877180a8693dfdba396"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "041fdcf23edb76cf8663073fa30a4195f5ce369ee0a2cf3447250f0372f5b1d8"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "bb31f66e30cc4619ea85828ada3a6c7dbe1dc47fb5caf165a7a47ae97dfa1106"
    sha256 cellar: :any_skip_relocation, sonoma:        "073d29aede1651760683ceae8c5d9c4f51e1686f55cc8269a7fb0dac9aa8d873"
    sha256 cellar: :any_skip_relocation, ventura:       "b80c49432472d51b8974e1beeb4b6f4d170b8fabf16d2fde95aef2b6e743b79f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2d7c228bbffb24cb72ae3b8305673746cd4c464fced2bd65a2d9999fd5c770e0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "be39ed2625d63d8c54df6fe89490d7d5d1530351521a0f3069680d6d6b931057"
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
