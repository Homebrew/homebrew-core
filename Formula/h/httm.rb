class Httm < Formula
  desc "Interactive, file-level Time Machine-like tool for ZFS/btrfs"
  homepage "https://github.com/kimono-koans/httm"
  url "https://github.com/kimono-koans/httm/archive/refs/tags/0.47.1.tar.gz"
  sha256 "30174bbf0ee2c29590e2ae768393ca7ffc302f2a4b4bc481f363f8e51cfcf757"
  license "MPL-2.0"
  head "https://github.com/kimono-koans/httm.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "fd1e4b21776718c195d290908adc114e55e9a9781efe9c674bec2d772c878454"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2b535b8f6af070b69c564685f95ab327280e50380c7340b9fdf9902fd0c47452"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "0d1d3f71082d7a3c857b1d521c7d7b50f87494dd896d4fde168e27722f127976"
    sha256 cellar: :any_skip_relocation, sonoma:        "451cd03a1a8f3d5f7fcaceed122e491aa0cf39a30844e4adcf1d2d595d32acba"
    sha256 cellar: :any_skip_relocation, ventura:       "3326dea5e03098bf848d4fd3d291df5d7af40434ffbd405391f63ed1127e20d8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9a1eba7d2901122f117ec77d693c41ab7daa8226fe9eaf8a544c56ab86141971"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d6210e69750e71567c1c429be7215be6f1e09489ea5d9df6d9140d009469992a"
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
