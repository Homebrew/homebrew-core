class Httm < Formula
  desc "Interactive, file-level Time Machine-like tool for ZFS/btrfs"
  homepage "https://github.com/kimono-koans/httm"
  url "https://github.com/kimono-koans/httm/archive/refs/tags/0.49.1.tar.gz"
  sha256 "e67dec5e347fbfd2563f334ede024aef1820f2fd5107091612a58a2d61308799"
  license "MPL-2.0"
  head "https://github.com/kimono-koans/httm.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "74f2606f213c24861088a530b61f871a13a8fb9778300c9157cb38e43ccc039e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a9f2b9362441d06121f4c213be1d2b9450bf73703b4f6292853689429a2b839f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9d468d6863a1a182b911847cdf7a76bcf9b1bee7ee7edc5dbf9baf18cbca589f"
    sha256 cellar: :any_skip_relocation, sonoma:        "6e4adb400d19e5c83c59e51006e7fc512bbab363cab2a7ae16c91cae16b027ad"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3bafce93d62efea34520814152e4687c8eb1a7ac3f17a2e63276a3488af714f3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f3a3c2cefc64e674147d1d9e52b27d80dda8728ac672f81c657fd1d833f9e040"
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
