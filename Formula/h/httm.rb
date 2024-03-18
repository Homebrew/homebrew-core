class Httm < Formula
  desc "Interactive, file-level Time Machine-like tool for ZFS/btrfs"
  homepage "https://github.com/kimono-koans/httm"
  url "https://github.com/kimono-koans/httm/archive/refs/tags/0.37.7.tar.gz"
  sha256 "d2f3dc3776a7a2aa378d5511d92e96baebaa35e22a8496e8087e7e58da01fd2e"
  license "MPL-2.0"
  head "https://github.com/kimono-koans/httm.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "55874fd0ac435717fe0c2ec623e0750fa608b1aad028bd2d0771056f14242a25"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "207720add481249495f8e8771bd6a33ee05189c2c8daea8e48e082e086ca8e3a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fc3b633d788e51e5d0489d897401783f9967bfa1b62e8b05a43423047fa87873"
    sha256 cellar: :any_skip_relocation, sonoma:         "a3caab669fc5a49f7059a9ed0be77a2c17e0efda17b971c4eee26c9dd69c82ef"
    sha256 cellar: :any_skip_relocation, ventura:        "e25688c7b4d17d1c371280fb195b3a71f9cbadc13ad6ec5ab0a942a4c0da4057"
    sha256 cellar: :any_skip_relocation, monterey:       "ecc0ea7cd30a3d41375408a48ef42dead93eace886b1e334a132150b53943b16"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8b457ad03c805227f1a1a31f49f7bbe074db0d0a152b1ae7ee8df581467c8036"
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
