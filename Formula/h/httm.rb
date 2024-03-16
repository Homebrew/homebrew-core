class Httm < Formula
  desc "Interactive, file-level Time Machine-like tool for ZFS/btrfs"
  homepage "https://github.com/kimono-koans/httm"
  url "https://github.com/kimono-koans/httm/archive/refs/tags/0.37.4.tar.gz"
  sha256 "27dff7c28a8ca8acc295973c67052d42c36557c1c423a46dbd2360f42aecca2c"
  license "MPL-2.0"
  head "https://github.com/kimono-koans/httm.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "fae3b36375ffa790c3c2e59466a83a1a67c9e4f7122e45f440af8fdcf67e62fb"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8d50ac0fd60d0ea617e712fc01411a710b1df267e1346cd4c3aa343be5395e6b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9fd58a6d289e2e4a179a1aeacf49f97503bf3fda43c412148b82133785ba26d6"
    sha256 cellar: :any_skip_relocation, sonoma:         "1d572003206b3e04177ece39ba13d277f6a8cd151de71c3cd5994cbdabfa2c03"
    sha256 cellar: :any_skip_relocation, ventura:        "d8da6b6149bded7bd2ad23b1a3cad43e61b99deb5d781715f8f0488b32530b84"
    sha256 cellar: :any_skip_relocation, monterey:       "71e1514276eae80654aa067539912b714c488a14087cb222242bd3ffc7297194"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "70b871459e160679163b7a4594287e7e057a9b54a63312cf8fa51a39ec17ed50"
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
