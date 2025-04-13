class Httm < Formula
  desc "Interactive, file-level Time Machine-like tool for ZFS/btrfs"
  homepage "https://github.com/kimono-koans/httm"
  url "https://github.com/kimono-koans/httm/archive/refs/tags/0.46.8.tar.gz"
  sha256 "0c34e6e783c5221d1b855a608360d73fbf1aea957ce977ce5781a8a30214bd0e"
  license "MPL-2.0"
  head "https://github.com/kimono-koans/httm.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ebbcfe651b0c0e1b521aa919be0d8768250c481069a91e0146bbde18f0df9d05"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8a70bbd12914229afe5355d4c29abc5aa0c9a0b66231bb007929aeaf840d7fb6"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ca70d6ce7afb2f73472a18b15deea51f50dc3bd3c25102c75c6d921195a340ee"
    sha256 cellar: :any_skip_relocation, sonoma:        "bbda125d38787b972347c0d956013705807b0a5db49c098b4c95c4a31d33da40"
    sha256 cellar: :any_skip_relocation, ventura:       "184dc6a0fa4227064d5223dd6a950e60132cb772aede5fa59b2994a0b268000d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "acd5770b769b5c4e8cab1aa19a0ecdc951e1bf716acf8a181a67c2eca43ead8f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cfff40ef3edb01440738f4bd955a55fbe49ef83c7ecb5d0535ae0752d3629773"
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
