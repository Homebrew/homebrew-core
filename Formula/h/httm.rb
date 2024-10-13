class Httm < Formula
  desc "Interactive, file-level Time Machine-like tool for ZFS/btrfs"
  homepage "https://github.com/kimono-koans/httm"
  url "https://github.com/kimono-koans/httm/archive/refs/tags/0.43.2.tar.gz"
  sha256 "aa5e59972a5db22502930bb4f1c911502d78a98d46a83fa8949f946296e663a0"
  license "MPL-2.0"
  head "https://github.com/kimono-koans/httm.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a0fcac86c1f36fdf94caea86df8db942b5cd43215cb16bda797f3a63c4000d60"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "778f01e626b14099a54c80b96bc98cca0dfbb039a7212f55bc405e1c080b407d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "fec750dc437d5507b53f9c4a76f53f511543fdfb7b8cc2045fadfe067659b994"
    sha256 cellar: :any_skip_relocation, sonoma:        "8d743040d8ed25b6401fd2235adb67aff0d648660d7acddf61d832935f0c1156"
    sha256 cellar: :any_skip_relocation, ventura:       "bff1fd4e07097dc0a1664c2263a657019f32ff2f36ba48c9d0ec9fb37867f452"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "74ffcb6e89cc7a480988bca805be6e612167d193a0b551e30ef816419421d651"
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
